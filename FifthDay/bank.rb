require_relative "validator"
require_relative "customer"
require_relative "account"
require_relative "transaction"
require_relative "loan"

class Bank

  ADMIN_PASSWORD = "admin123"

  def initialize

    @customers = {}
    @accounts = {}
    @transactions = Hash.new { |h,k| h[k] = [] }
    @loans = {}

    @customer_counter = 1
    @loan_counter = 1

    @txn_counter = Hash.new(0)

  end

  def authenticate(id)

  account = @accounts[id]

  raise "Account not found" unless account
  raise "Account locked" if account.locked

  print "Enter password: "
  pass = gets.chomp

  if pass == account.password
    account.failed_attempts = 0
    return true
  else

    account.failed_attempts += 1

    if account.failed_attempts >= 3
      account.locked = true
      raise "Account locked due to multiple failed attempts"
    end

    raise "Wrong password"

  end
  end

  def add_balance(id, amount)
  @accounts[id].balance += amount
  end

  def ensure_balance(id, amount)
  if @accounts[id].balance < amount
    raise "Insufficient balance"
  end
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
  raise "Password must be at least 4 characters" if password.length < 4
  id = @customer_counter
  customer = Customer.new(id, name, email, phone, address)
  account = Account.new(password)
  @customers[id] = customer
  @accounts[id] = account
  @customer_counter += 1
  puts "Customer created successfully"
  puts "Customer ID: #{id}"
  end



  def deposit(id, amount)

  Validator.customer_exists(@customers, id)
  Validator.amount(amount)

  customer = @customers[id]

  raise "Account frozen" if customer.status == :frozen
  raise "Account closed" if customer.status == :closed

  authenticate(id)

  add_balance(id, amount)

  record_transaction(id, :deposit, amount)

  puts "Deposit successful"
  puts "New Balance: #{@accounts[id].balance}"

  end



  def withdraw(id, amount)

  Validator.customer_exists(@customers, id)
  Validator.amount(amount)

  customer = @customers[id]

  raise "Account frozen" if customer.status == :frozen
  raise "Account closed" if customer.status == :closed

  authenticate(id)

  deduct_balance(id, amount)

  record_transaction(id, :withdraw, amount)

  puts "Withdraw successful"
  puts "Remaining Balance: #{@accounts[id].balance}"

  end



  def transfer(from, to, amount)

  Validator.customer_exists(@customers, from)
  Validator.customer_exists(@customers, to)
  Validator.amount(amount)

  sender = @customers[from]
  receiver = @customers[to]

  raise "Sender account frozen" if sender.status == :frozen
  raise "Sender account closed" if sender.status == :closed

  raise "Receiver account frozen" if receiver.status == :frozen
  raise "Receiver account closed" if receiver.status == :closed

  authenticate(from)

  deduct_balance(from, amount)
  add_balance(to, amount)

  time = Time.now

  record_transaction(from, :transfer_sent, amount, {to: to}, time)
  record_transaction(to, :transfer_received, amount, {from: from}, time)

  puts "Transfer successful"

  end

  def approve_loan(id, amount, years)

    Validator.customer_exists(@customers, id)
    Validator.amount(amount)

    customer = @customers[id]

    raise "Account frozen" if customer.status == :frozen
    raise "Account closed" if customer.status == :closed

    authenticate(id)

    loan_id = @loan_counter

    loan = Loan.new(loan_id, id, amount, years)

    @loans[loan_id] = loan

    @loan_counter += 1

    add_balance(id, amount)

    @accounts[id].loan_total += amount

    record_transaction(id, :loan_taken, amount)

    puts "Loan approved"
    puts "Loan ID: #{loan_id}"
    puts "EMI: #{loan.emi}"
    puts "Remaining Balance: #{loan.remaining_balance}"

  end


  def repay_loan(id, amount)

    Validator.customer_exists(@customers, id)
    Validator.amount(amount)

    customer = @customers[id]

    raise "Account frozen" if customer.status == :frozen
    raise "Account closed" if customer.status == :closed

    authenticate(id)

    loans = @loans.select { |_,loan| loan.customer_id == id && loan.status == :active }

    raise "No active loan found" if loans.empty?

    loan_id, loan = loans.first

    account = @accounts[id]

    ensure_balance(id, amount)

    now = Time.now
    days = ((now - loan.last_payment_date) / (60*60*24)).to_i

    interest = (loan.remaining_balance * loan.rate * days / 365).round(2)

    total_due = loan.remaining_balance + interest

    payment = [amount, total_due].min

    deduct_balance(id, payment)

    if payment >= interest
      principal_payment = payment - interest
    else
      principal_payment = 0
    end

    loan.remaining_balance -= principal_payment

    loan.last_payment_date = now

    if loan.remaining_balance <= 0
      loan.remaining_balance = 0
      loan.status = :paid
      puts "Loan fully repaid"
    else
      puts "Remaining loan balance: #{loan.remaining_balance.round(2)}"
    end

    record_transaction(id, :loan_payment, payment, {loan_id: loan_id})

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
      puts "No transactions found"
      return
    end

    puts "TxnID | Type | Amount | Balance | Time"

    txns.each do |t|

      puts "#{t.txn_id} | #{t.type} | #{t.amount} | #{t.balance_after} | #{t.time}"

    end

  end



  def admin_auth

    print "Enter admin password: "
    pass = gets.chomp

    raise "Wrong admin password" unless pass == ADMIN_PASSWORD

  end



  def view_customers
  if @customers.empty?
    puts "No customers found"
    return
  end

  puts "ID | Name | Status"

  @customers.each do |id, customer|
    puts "#{id} | #{customer.name} | #{customer.status}"
  end

  end


  def show_locked_accounts

    locked = @accounts.select { |id,acc| acc.locked }

    if locked.empty?
      puts "No locked accounts"
      return
    end

    puts "Locked Accounts:"

    locked.each do |id,_|
      puts "#{id} #{@customers[id].name}"
    end

  end


  def unlock_account(id)

    account = @accounts[id]

    raise "Account not found" unless account
    raise "Account not locked" unless account.locked

    account.failed_attempts = 0
    account.locked = false

    puts "Account unlocked"

  end


  def show_frozen_accounts

    frozen = @customers.select { |_,c| c.status == :frozen }

    if frozen.empty?
      puts "No frozen accounts"
      return
    end

    puts "Frozen Accounts:"

    frozen.each do |id,c|
      puts "#{id} #{c.name}"
    end

  end



  def freeze_account(id)
  Validator.customer_exists(@customers,id)

  customer = @customers[id]

  customer.status = :frozen

  puts "Account frozen"
  end



  def unfreeze_account(id)
  Validator.customer_exists(@customers,id)

  customer = @customers[id]

  customer.status = :active

  puts "Account unfrozen"
  end

  def close_account(id)
  Validator.customer_exists(@customers,id)

  customer = @customers[id]

  customer.status = :closed

  puts "Account closed"
  end


  def delete_customer(id)

  Validator.customer_exists(@customers,id)

  @customers.delete(id)
  @accounts.delete(id)
  @transactions.delete(id)

  puts "Customer deleted"

  end


  
end