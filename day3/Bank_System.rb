module Bank_System

class Bank

  def initialize
    @customers = {}
    @transactions = {}
    @transaction_counter = 0
  end


  def add_account(name,email,phone,address)

    id = @customers.empty? ? 1 : @customers.keys.max + 1

    @customers[id] = Account.new(name,email,phone,address)

    puts "Account created. Customer ID = #{id}"

  end


  def deposit(id,amount)

    customer = @customers[id] or raise "Customer Not Found"

    customer.deposit(amount)

    add_transaction("Deposit",id,amount)

  end


  def withdraw(id,amount)

    customer = @customers[id] or raise "Customer Not Found"

    customer.withdraw(amount)

    add_transaction("Withdraw",id,amount)

  end


  def take_loan(id,amount)

    customer = @customers[id] or raise "Customer Not Found"

    customer.take_loan(amount)

    emi = customer.emi_calc(amount)

    puts "Loan Approved"
    puts "Monthly EMI = #{emi}"

  end


  def transfer(from,to,amount)

    sender = @customers[from] or raise "Sender Not Found"
    receiver = @customers[to] or raise "Receiver Not Found"

    raise "Insufficient Balance" if sender.balance < amount

    sender.withdraw(amount)
    receiver.deposit(amount)

    add_transaction("Transfer Sent",from,amount,{to:to})
    add_transaction("Transfer Received",to,amount,{from:from})

  end


  def show_customer(id)

    customer = @customers[id] or raise "Customer Not Found"

    puts "Name: #{customer.name}"
    puts "Email: #{customer.email}"
    puts "Phone: #{customer.phone}"
    puts "Address: #{customer.address}"
    puts "Balance: #{customer.balance}"
    puts "Loan: #{customer.loan_amount}"

  end


  def show_transactions

    if @transactions.empty?
      puts "No Transactions"
      return
    end

    @transactions.each do |id,t|

      puts "TxnID: #{id} | #{t[:type]} | #{t[:amount]} | #{t[:date]}"

    end

  end


  private

  def add_transaction(type,id,amount,extra={})

    @transaction_counter += 1

    @transactions[@transaction_counter] = {
      type: type,
      customer_id: id,
      amount: amount,
      details: extra,
      date: Time.now
    }

  end

end



class Account

  attr_accessor :name, :email, :phone, :address, :balance, :loan_amount

  INTEREST = 0.10
  PERIOD = 12.0


  def initialize(name,email,phone,address,balance=0,loan_amount=0)

    @name = name
    @email = email
    @phone = phone
    @address = address
    @balance = balance
    @loan_amount = loan_amount

  end


  def deposit(amount)

    @balance += amount

  end


  def withdraw(amount)

    raise "Insufficient Balance" if amount > @balance

    @balance -= amount

  end


  def take_loan(amount)

    @balance += amount
    @loan_amount += amount

  end


  def emi_calc(amount)

    total = amount + (amount * INTEREST)

    (total / PERIOD).round(2)

  end

end

end