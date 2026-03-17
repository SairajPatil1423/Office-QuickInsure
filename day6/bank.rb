# frozen_string_literal: true

require 'digest'
require_relative 'validator'
require_relative 'customer'
require_relative 'account'
require_relative 'transaction'
require_relative 'loan'

class Bank
  ADMIN_PASSWORD_HASH = Digest::SHA256.hexdigest('admin123')

  def initialize
    @customers    = {}
    @accounts     = {}
    @transactions = Hash.new { |h, k| h[k] = [] }
    @loans        = {}

    @customer_counter = 1
    @loan_counter     = 1
    @txn_counter      = Hash.new(0)
  end

  def admin_auth
    print 'Enter admin password: '
    input = gets.chomp
    raise 'Wrong admin password' unless Digest::SHA256.hexdigest(input) == ADMIN_PASSWORD_HASH
  end

  def authenticate(id)
    account = @accounts[id]
    raise 'Account not found' unless account
    raise 'Account locked'    if account.locked

    print 'Enter password: '
    pass = gets.chomp

    if account.correct_password?(pass)
      account.failed_attempts = 0
    else
      account.failed_attempts += 1
      if account.failed_attempts >= 3
        account.locked = true
        raise 'Account locked due to multiple failed attempts'
      end
      raise "Wrong password (#{3 - account.failed_attempts} attempts left)"
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
    txn_id  = "#{id}-#{@txn_counter[id]}"
    balance = @accounts[id].balance
    txn     = Transaction.new(txn_id, type, amount, balance, details, time)
    @transactions[id] << txn
  end

  def assert_active!(id, label = 'Account')
    customer = @customers[id]
    raise "#{label} frozen" if customer.status == :frozen
    raise "#{label} closed" if customer.status == :closed
  end

  def create_customer(name, email, phone, address, password)
    Validator.name(name)
    Validator.email(email)
    Validator.phone(phone)
    Validator.address(address)
    Validator.password(password)
    Validator.duplicate_email(@customers, email)
    Validator.duplicate_phone(@customers, phone)

    id       = @customer_counter
    customer = Customer.new(id, name.strip, email.strip, phone.strip, address.strip)
    account  = Account.new(password)

    @customers[id] = customer
    @accounts[id]  = account
    @customer_counter += 1

    puts 'Customer created successfully'
    puts "Customer ID: #{id}"
  end

  def deposit(id, amount)
    Validator.customer_exists(@customers, id)
    Validator.amount(amount)
    assert_active!(id)
    authenticate(id)

    add_balance(id, amount)
    record_transaction(id, :deposit, amount)

    puts 'Deposit successful'
    puts "New Balance: #{@accounts[id].balance}"
  end

  def withdraw(id, amount)
    Validator.customer_exists(@customers, id)
    Validator.amount(amount)
    assert_active!(id)
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

    raise 'Cannot transfer to yourself' if from == to

    assert_active!(from, 'Sender account')
    assert_active!(to,   'Receiver account')
    authenticate(from)

    deduct_balance(from, amount)
    add_balance(to, amount)

    time = Time.now
    record_transaction(from, :transfer_sent,     amount, { to: to },     time)
    record_transaction(to,   :transfer_received, amount, { from: from }, time)

    puts 'Transfer successful'
  end

  def approve_loan(id, amount, years)
    Validator.customer_exists(@customers, id)
    Validator.amount(amount)
    Validator.loan_years(years)
    assert_active!(id)
    authenticate(id)

    loan_id = @loan_counter
    loan    = Loan.new(loan_id, id, amount, years)

    @loans[loan_id] = loan
    @loan_counter  += 1

    add_balance(id, amount)
    @accounts[id].loan_total += amount
    record_transaction(id, :loan_taken, amount)

    puts 'Loan approved'
    puts "Loan ID: #{loan_id}"
    puts "EMI: #{loan.emi}"
    puts "Total Payable: #{loan.remaining_balance}"
  end

  def pay_monthly_emi(id)
    Validator.customer_exists(@customers, id)
    assert_active!(id)
    authenticate(id)

    loans = @loans.select { |_, l| l.customer_id == id && l.status == :active }
    raise 'No active loan found' if loans.empty?

    loan_id, loan = loans.first
    emi = loan.emi

    ensure_balance(id, emi)
    deduct_balance(id, emi)

    interest  = (loan.remaining_balance * loan.rate / 12).round(2)
    principal = emi - interest

    loan.remaining_balance -= principal
    loan.remaining_balance = loan.remaining_balance.round(2)

    if loan.remaining_balance <= 0
      loan.remaining_balance = 0
      loan.status = :paid
      puts 'Loan fully repaid'
    else
      puts "EMI Paid: #{emi}"
      puts "Interest: #{interest}"
      puts "Principal: #{principal}"
      puts "Remaining balance: #{loan.remaining_balance}"
    end

    record_transaction(id, :emi_payment, emi, { loan_id: loan_id })
  end

  def flexible_loan_payment(id, amount)
    Validator.customer_exists(@customers, id)
    Validator.amount(amount)
    assert_active!(id)
    authenticate(id)

    loans = @loans.select { |_, l| l.customer_id == id && l.status == :active }
    raise 'No active loan found' if loans.empty?

    loan_id, loan = loans.first

    ensure_balance(id, amount)
    deduct_balance(id, amount)

    interest = (loan.remaining_balance * loan.rate / 12).round(2)

    if amount < loan.emi
      puts 'Partial payment'

      if amount <= interest
        puts 'Only interest covered'
      else
        principal = amount - interest
        loan.remaining_balance -= principal
        puts "Principal reduced by #{principal}"
      end
    else
      puts 'Extra payment detected'

      loan.remaining_balance -= amount

      months_left = (loan.years * 12)
      loan.instance_variable_set(
        :@emi,
        (loan.remaining_balance / months_left.to_f).round(2)
      )

      puts "New EMI: #{loan.emi}"
    end

    loan.remaining_balance = loan.remaining_balance.round(2)

    if loan.remaining_balance <= 0
      loan.remaining_balance = 0
      loan.status = :paid
      puts 'Loan fully repaid'
    else
      puts "Remaining balance: #{loan.remaining_balance}"
    end

    record_transaction(id, :flexible_payment, amount, { loan_id: loan_id })
  end

  def show_customer(id)
    Validator.customer_exists(@customers, id)

    customer = @customers[id]
    account  = @accounts[id]

    puts "Customer ID : #{customer.id}"
    puts "Name        : #{customer.name}"
    puts "Email       : #{customer.email}"
    puts "Phone       : #{customer.phone}"
    puts "Address     : #{customer.address}"
    puts "Status      : #{customer.status}"
    puts "Role        : #{customer.role}"
    puts "Balance     : #{account.balance}"
    puts "Loan Total  : #{account.loan_total}"
  end

  def show_transactions(id)
    Validator.customer_exists(@customers, id)

    txns = @transactions[id]
    if txns.empty?
      puts 'No transactions found'
      return
    end

    puts "\n#{'TxnID'.ljust(10)} #{'Type'.ljust(20)} #{'Amount'.ljust(12)} #{'Balance'.ljust(12)} Time"
    puts '-' * 70
    txns.each do |t|
      puts "#{t.txn_id.to_s.ljust(10)} #{t.type.to_s.ljust(20)} #{t.amount.to_s.ljust(12)} #{t.balance_after.to_s.ljust(12)} #{t.time}"
    end
  end

  #   Admin operations

  def view_customers
    if @customers.empty?
      puts 'No customers found'
      return
    end

    puts "\n#{'ID'.ljust(5)} #{'Name'.ljust(20)} #{'Email'.ljust(25)} #{'Status'.ljust(10)} Balance"
    puts '-' * 75
    @customers.each do |id, c|
      puts "#{id.to_s.ljust(5)} #{c.name.ljust(20)} #{c.email.ljust(25)} #{c.status.to_s.ljust(10)} #{@accounts[id].balance}"
    end
  end

  def show_locked_accounts
    locked = @accounts.select { |_, a| a.locked }
    if locked.empty?
      puts 'No locked accounts'
      return
    end

    puts "\nLocked accounts:"
    locked.each_key do |id|
      puts "  ID: #{id} | Name: #{@customers[id].name}"
    end
  end

  def unlock_account(id)
    Validator.customer_exists(@customers, id)
    raise 'Account is not locked' unless @accounts[id].locked


    @accounts[id].locked          = false
    @accounts[id].failed_attempts = 0
    puts "Account #{id} unlocked"
  end

  def show_frozen_accounts
    frozen = @customers.select { |_, c| c.status == :frozen }
    if frozen.empty?
      puts 'No frozen accounts'
      return
    end

    puts "\nFrozen accounts:"
    frozen.each do |id, c|
      puts "  ID: #{id} | Name: #{c.name}"
    end
  end

  def freeze_account(id)
    Validator.customer_exists(@customers, id)
    raise 'Account is already frozen' if @customers[id].status == :frozen
    raise 'Account is closed'         if @customers[id].status == :closed

    @customers[id].status = :frozen
    puts "Account #{id} frozen"
  end

  def unfreeze_account(id)
    Validator.customer_exists(@customers, id)
    raise 'Account is not frozen' unless @customers[id].status == :frozen

    @customers[id].status = :active
    puts "Account #{id} unfrozen"
  end

  def close_account(id)
    Validator.customer_exists(@customers, id)
    raise 'Account is already closed' if @customers[id].status == :closed

    active_loans = @loans.select { |_, l| l.customer_id == id && l.status == :active }
    raise 'Cannot close account with active loans' unless active_loans.empty?

    @customers[id].status = :closed
    puts "Account #{id} closed"
  end

  def delete_customer(id)
    Validator.customer_exists(@customers, id)

    active_loans = @loans.select { |_, l| l.customer_id == id && l.status == :active }
    raise 'Cannot delete customer with active loans' unless active_loans.empty?

    raise "Balance must be 0 to delete (current: #{@accounts[id].balance})" if @accounts[id].balance.positive?

    @customers.delete(id)
    @accounts.delete(id)
    @transactions.delete(id)
    puts "Customer #{id} deleted"
  end

  def risky_loans_total
    found = false
    @customers.each do |id, customer|
      account = @accounts[id]
      next unless account.loan_total > 5 * account.balance

      found = true
      puts "Customer ID: #{id} | Name: #{customer.name} | Loan: #{account.loan_total} | Balance: #{account.balance}"
    end
    puts 'No risky customers found' unless found
  end

  def prepayment_impact(id, payment = 5000)
    Validator.customer_exists(@customers, id)

    loans = @loans.select { |_, l| l.customer_id == id && l.status == :active }
    raise 'No active loans found' if loans.empty?

    loans.each do |loan_id, loan|
      months_before = (loan.remaining_balance / loan.emi.to_f).ceil
      new_balance   = [loan.remaining_balance - payment, 0].max
      months_after  = (new_balance / loan.emi.to_f).ceil
      months_saved  = months_before - months_after

      puts "Loan #{loan_id}: #{months_saved} months saved by paying #{payment} extra"
      puts "  Balance #{loan.remaining_balance} → #{new_balance} | EMI: #{loan.emi}"
    end
  end

  def projected_interest_next_year
    total = @loans.values
                  .select { |l| l.status == :active }
                  .sum { |l| l.remaining_balance * l.rate }

    if total.zero?
      puts 'No active loans'
      return
    end

    puts "Projected interest (next 12 months): #{total.round(2)}"
  end
end
