module BankSystem

INTEREST = 0.10
PERIOD = 12.0

class Customer
  attr_accessor :id, :name, :email, :phone, :address

  def initialize(id,name,email,phone,address)
    @id = id
    @name = name
    @email = email
    @phone = phone
    @address = address
  end
end


class Account
  attr_accessor :customer_id,:balance,:loan_amount

  def initialize(customer_id,balance=0,loan_amount=0)
    @customer_id = customer_id
    @balance = balance
    @loan_amount = loan_amount
  end

  def deposit(amount)
    @balance += amount
  end

  def withdraw(amount)
    raise "Insufficient balance" if amount > @balance
    @balance -= amount
  end

  def take_loan(amount)
    @balance += amount
    @loan_amount += amount
  end
end


class Transaction
  attr_accessor :txn_id,:customer_id,:type,:amount,:time,:details

  def initialize(txn_id,customer_id,type,amount,details={})
    @txn_id = txn_id
    @customer_id = customer_id
    @type = type
    @amount = amount
    @details = details
    @time = Time.now
  end
end


class Loan
  attr_accessor :loan_id,:customer_id,:loan_amount,:status,:emi

  def initialize(loan_id,customer_id,loan_amount,emi)
    @loan_id = loan_id
    @customer_id = customer_id
    @loan_amount = loan_amount
    @status = :approved
    @emi = emi
  end
end


class Bank

  def initialize
    @customers = {}
    @accounts = {}
    @transactions = Hash.new { |h,k| h[k] = [] }
    @loans = Hash.new { |h,k| h[k] = [] }

    @txn_counter = 1
    @loan_counter = 1
  end


  def create_customer(name,email,phone,address)

    id = @customers.empty? ? 1 : @customers.keys.max + 1

    @customers[id] = Customer.new(id,name,email,phone,address)
    @accounts[id] = Account.new(id)

    puts "Customer created. ID = #{id}"
  end


  def deposit(id,amount)

    account = @accounts[id] or raise "Customer not found"

    account.deposit(amount)

    record_transaction(id,:deposit,amount)

    puts "Deposit successful"
  end


  def withdraw(id,amount)

    account = @accounts[id] or raise "Customer not found"

    account.withdraw(amount)

    record_transaction(id,:withdraw,amount)

    puts "Withdraw successful"
  end


  def transfer(from,to,amount)

    sender = @accounts[from] or raise "Sender not found"
    receiver = @accounts[to] or raise "Receiver not found"

    sender.withdraw(amount)
    receiver.deposit(amount)

    time = Time.now

    record_transaction(from,:transfer_sent,amount,{to:to},time)
    record_transaction(to,:transfer_received,amount,{from:from},time)

    puts "Transfer successful"
  end


  def approve_loan(id,amount)

    account = @accounts[id] or raise "Customer not found"

    emi = emi_calc(amount)

    account.take_loan(amount)

    loan = Loan.new(@loan_counter,id,amount,emi)

    @loans[id] << loan

    @loan_counter += 1

    puts "Loan Approved"
    puts "EMI = #{emi}"
  end


  def show_customer(id)

    customer = @customers[id] or raise "Customer not found"
    account = @accounts[id]

    puts "Name: #{customer.name}"
    puts "Email: #{customer.email}"
    puts "Phone: #{customer.phone}"
    puts "Address: #{customer.address}"
    puts "Balance: #{account.balance}"
    puts "Loan: #{account.loan_amount}"
  end


  def show_transactions(id)

    txns = @transactions[id]

    if txns.empty?
      puts "No transactions"
      return
    end

    txns.each do |t|
      puts "#{t.txn_id} | #{t.type} | #{t.amount} | #{t.time}"
    end
  end


  def show_loans(id)

    loans = @loans[id]

    if loans.empty?
      puts "No loans found"
      return
    end

    loans.each do |l|
      puts "Loan ID: #{l.loan_id} | Amount: #{l.loan_amount} | EMI: #{l.emi} | Status: #{l.status}"
    end
  end


  def maximum_transaction

    raise "No transactions found" if @transactions.empty?

    max_customer = nil
    max_amount = 0

    @transactions.each do |customer_id,txns|

      total = txns.sum { |t| t.amount }

      if total > max_amount
        max_amount = total
        max_customer = customer_id
      end
    end

    puts "Customer ID: #{max_customer} | Transaction Amount: #{max_amount}"
  end


  def fraud_customer

    @loans.each do |customer_id,loans|

      total_loan = loans.sum { |l| l.loan_amount }

      balance = @accounts[customer_id].balance

      if balance < total_loan
        puts "Fraud Risk Customer ID: #{customer_id} | Balance: #{balance} | Loan: #{total_loan}"
      end
    end
  end


  def transactions_between(id1,id2)

    found = false

    [@transactions[id1],@transactions[id2]].each do |txns|

      txns.each do |t|

        next unless t.type == :transfer_sent

        from = id1
        to = t.details[:to]

        if (from == id1 && to == id2) || (from == id2 && to == id1)
          puts "From #{from} -> To #{to} | Amount: #{t.amount} | Time: #{t.time}"
          found = true
        end
      end
    end

    puts "No transactions between #{id1} and #{id2}" unless found
  end


  private


  def emi_calc(amount)
    total = amount + (amount * INTEREST)
    (total / PERIOD).round(2)
  end


  def record_transaction(customer_id,type,amount,details={},time=Time.now)

    txn = Transaction.new(@txn_counter,customer_id,type,amount,details)

    txn.time = time

    @transactions[customer_id] << txn

    @txn_counter += 1
  end

end

end