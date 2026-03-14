# frozen_string_literal: true

require_relative 'validator'
require_relative 'customer'
require_relative 'account'
require_relative 'transaction'
require_relative 'loan'

class Bank
  ADMIN_PASSWORD = 'admin123'

  def initialize
    @customers = {}
    @accounts = {}
    @transactions = Hash.new { |h, k| h[k] = [] }
    @loans = {}

    @customer_counter = 1
    @loan_counter = 1

    @txn_counter = Hash.new(0)
  end

  def authenticate(id)
    account = @accounts[id]

    raise 'Account not found' unless account
    raise 'Account locked' if account.locked

    print 'Enter password: '
    pass = gets.chomp

    if pass == account.password
      account.failed_attempts = 0
      true
    else
      account.failed_attempts += 1

      if account.failed_attempts >= 3
        account.locked = true
        raise 'Account locked due to multiple failed attempts'
      end

      raise 'Wrong password'
    end
  end

  def add_balance(id, amount)
    @accounts[id].balance += amount
  end

  def ensure_balance(id, amount)
    raise 'Insufficient balance' if @accounts[id].balance < amount
  end

  def deduct_balance(id, amount)
    ensure_balance(id, amount)
    @accounts[id].balance -= amount
  end

  def record_transaction(id, type, amount, details = {}, time = nil)
    @txn_counter[id] += 1
    txn_id = "#{id}-#{@txn_counter[id]}"

    balance = @accounts[id].balance

    txn = Transaction.new(txn_id, type, amount, balance, details, time)
    @transactions[id] << txn
  end

  def create_customer(name, email, phone, address, password)
    Validator.name(name)
    Validator.email(email)
    Validator.phone(phone)
    Validator.address(address)
    Validator.duplicate_email(@customers, email)
    Validator.duplicate_phone(@customers, phone)

    raise 'Password must be at least 4 characters' if password.length < 4

    id = @customer_counter
    customer = Customer.new(id, name, email, phone, address)
    account = Account.new(password)

    @customers[id] = customer
    @accounts[id] = account

    @customer_counter += 1

    puts 'Customer created successfully'
    puts "Customer ID: #{id}"
  end

  def deposit(id, amount)
    Validator.customer_exists(@customers, id)
    Validator.amount(amount)

    customer = @customers[id]

    raise 'Account frozen' if customer.status == :frozen
    raise 'Account closed' if customer.status == :closed

    authenticate(id)

    add_balance(id, amount)
    record_transaction(id, :deposit, amount)

    puts 'Deposit successful'
    puts "New Balance: #{@accounts[id].balance}"
  end

  def withdraw(id, amount)
    Validator.customer_exists(@customers, id)
    Validator.amount(amount)

    customer = @customers[id]

    raise 'Account frozen' if customer.status == :frozen
    raise 'Account closed' if customer.status == :closed

    authenticate(id)

    deduct_balance(id, amount)
    record_transaction(id, :withdraw, amount)

    puts 'Withdraw successful'
    puts "Remaining Balance: #{@accounts[id].balance}"
  end

  def transfer(from, to, amount)
    Validator.customer_exists(@customers, from)
    Validator.customer_exists(@customers, to)
    Validator.amount(amount)

    sender = @customers[from]
    receiver = @customers[to]

    raise 'Sender account frozen' if sender.status == :frozen
    raise 'Sender account closed' if sender.status == :closed

    raise 'Receiver account frozen' if receiver.status == :frozen
    raise 'Receiver account closed' if receiver.status == :closed

    authenticate(from)

    deduct_balance(from, amount)
    add_balance(to, amount)

    time = Time.now

    record_transaction(from, :transfer_sent, amount, { to: to }, time)
    record_transaction(to, :transfer_received, amount, { from: from }, time)

    puts 'Transfer successful'
  end

  def approve_loan(id, amount, years)
    Validator.customer_exists(@customers, id)
    Validator.amount(amount)

    customer = @customers[id]

    raise 'Account frozen' if customer.status == :frozen
    raise 'Account closed' if customer.status == :closed

    authenticate(id)

    loan_id = @loan_counter
    loan = Loan.new(loan_id, id, amount, years)

    @loans[loan_id] = loan
    @loan_counter += 1

    add_balance(id, amount)
    @accounts[id].loan_total += amount

    record_transaction(id, :loan_taken, amount)

    puts 'Loan approved'
    puts "Loan ID: #{loan_id}"
    puts "EMI: #{loan.emi}"
    puts "Remaining Balance: #{loan.remaining_balance}"
  end

  def repay_loan(id, amount)
    Validator.customer_exists(@customers, id)
    Validator.amount(amount)

    customer = @customers[id]

    raise 'Account frozen' if customer.status == :frozen
    raise 'Account closed' if customer.status == :closed

    authenticate(id)

    loans = @loans.select { |_, loan| loan.customer_id == id && loan.status == :active }
    raise 'No active loan found' if loans.empty?

    loan_id, loan = loans.first

    ensure_balance(id, amount)

    now = Time.now
    days = ((now - loan.last_payment_date) / (60 * 60 * 24)).to_f

    interest = (loan.remaining_balance * loan.rate * days / 365).round(2)
    total_due = loan.remaining_balance + interest

    payment = [amount, total_due].min

    deduct_balance(id, payment)

    principal_payment = payment >= interest ? payment - interest : 0

    loan.remaining_balance -= principal_payment
    loan.last_payment_date = now

    if loan.remaining_balance <= 0
      loan.remaining_balance = 0
      loan.status = :paid
      puts 'Loan fully repaid'
    else
      puts "Remaining loan balance: #{loan.remaining_balance.round(2)}"
    end

    record_transaction(id, :loan_payment, payment, { loan_id: loan_id })
  end

  def show_customer(id)
    Validator.customer_exists(@customers, id)

    customer = @customers[id]
    account = @accounts[id]

    puts "Customer ID: #{customer.id}"
    puts "Name: #{customer.name}"
    puts "Email: #{customer.email}"
    puts "Phone: #{customer.phone}"
    puts "Address: #{customer.address}"
    puts "Status: #{customer.status}"
    puts "Role: #{customer.role}"
    puts "Balance: #{account.balance}"
    puts "Loan Taken: #{account.loan_total}"
  end

  def show_transactions(id)
    Validator.customer_exists(@customers, id)

    txns = @transactions[id]

    if txns.empty?
      puts 'No transactions found'
      return
    end

    puts 'TxnID | Type | Amount | Balance | Time'

    txns.each do |t|
      puts "#{t.txn_id} | #{t.type} | #{t.amount} | #{t.balance_after} | #{t.time}"
    end
  end

  #  Queries ->

  def risky_loans_total
    @customers.each do |id, customer|
      account = @accounts[id]

      next unless account.loan_total > 5 * account.balance

      puts "Customer ID: #{id}"
      puts "Name: #{customer.name}"
      puts "Total Loan: #{account.loan_total}"
      puts "Balance: #{account.balance}"

    end
  end

  def prepayment_impact(id, payment = 5000)
    Validator.customer_exists(@customers, id)

    loans = @loans.select { |_, loan| loan.customer_id == id && loan.status == :active }
    raise 'No active loans found' if loans.empty?

    loans.each do |loan_id, loan|
      months_before = (loan.remaining_balance / loan.emi.to_f).ceil

      new_balance = [loan.remaining_balance - payment, 0].max
      months_after = (new_balance / loan.emi.to_f).ceil

      months_saved = months_before - months_after

      puts "Loan ID: #{loan_id}"
      puts "Remaining Balance: #{loan.remaining_balance}"
      puts "EMI: #{loan.emi}"
      puts "Months Remaining: #{months_before}"

      puts "After paying #{payment} principal:"
      puts "New Balance: #{new_balance}"
      puts "New Months Remaining: #{months_after}"

      puts "Tenure Reduced By: #{months_saved} months"

    end
  end

  def projected_interest_next_year
    total_interest = @loans.values
                           .select { |loan| loan.status == :active }
                           .sum { |loan| loan.remaining_balance * loan.rate }

    if total_interest.zero?
      puts 'No active loans'
      return
    end

    puts "Total projected interest for next 12 months: #{total_interest.round(2)}"
  end
end