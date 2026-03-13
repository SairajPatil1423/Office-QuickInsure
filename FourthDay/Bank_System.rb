module BankSystem

INTEREST = 0.10


class Validator

  def self.customer_exists(customers,id)
    raise "Customer not found" unless customers[id]
  end

  def self.amount(amount)
    raise "Invalid amount" if amount <= 0
  end

  def self.email(email)
    raise "Invalid email" unless email.match?(/\A.+@.+\..+\z/)
  end

  def self.phone(phone)
    raise "Invalid phone" unless phone.match?(/^\d{10}$/)
  end

  def self.name(name)
    raise "Name must contain only alphabets" unless name.match?(/\A[a-zA-Z]+\z/)
    raise "Name must be longer than 3 characters" unless name.length > 3
  end

  def self.address(address)
    raise "Address must contain only alphabets" unless address.match?(/\A[a-zA-Z]+\z/)
    raise "Address must be longer than 3 characters" unless address.length > 3
  end

  def self.duplicate_email(customers,email)
    exists = customers.values.any? { |c| c.email.downcase == email.downcase }
    raise "Email already registered" if exists
  end

  def self.duplicate_phone(customers,phone)
    exists = customers.values.any? { |c| c.phone == phone }
    raise "Phone already registered" if exists
  end

end



class Customer

  attr_reader :id, :name, :email, :phone, :address

  def initialize(id,name,email,phone,address)
    @id=id
    @name=name
    @email=email
    @phone=phone
    @address=address
  end

end



class Account

  attr_accessor :balance, :loan_amount, :password

  def initialize
    @balance = 0
    @loan_amount = 0
    @password = nil
  end

end



class Transaction

  attr_reader :txn_id,:type,:amount,:time,:details

  def initialize(txn_id,type,amount,details={},time=nil)
    @txn_id=txn_id
    @type=type
    @amount=amount
    @details=details
    @time=time || Time.now
  end

end



class Loan

  attr_reader :customer_id,:loan_amount,:emi,:years,:due_date
  attr_accessor :remaining,:status

  def initialize(customer_id,amount,years)

    @customer_id = customer_id
    @loan_amount = amount
    @years = years
    @status = :approved

    months = years * 12
    interest = amount * INTEREST * years
    total = amount + interest

    @emi = (total / months).round(2)

    @remaining = total

    @due_date = Time.now + (years * 365 * 24 * 60 * 60)

  end

end



class Bank

  def initialize

    @customers={}
    @accounts={}
    @transactions=Hash.new{|h,k| h[k]=[]}
    @loans={}

    @txn_counter=1
    @loan_counter=1

  end



  def authenticate(id)

    account=@accounts[id]

    if account.password.nil?
      print "Set new password: "
      account.password = gets.chomp
      puts "Password created"
    end

    print "Enter password: "
    pass = gets.chomp

    raise "Authentication failed" unless pass == account.password

  end


  def ensure_balance(id,amount)
    raise "Insufficient balance" if @accounts[id].balance < amount
  end


  def add_balance(id,amount)
    @accounts[id].balance += amount
  end


  def deduct_balance(id,amount)
    ensure_balance(id,amount)
    @accounts[id].balance -= amount
  end


  def record_transaction(id,type,amount,extra={},time=nil)

    txn = Transaction.new(@txn_counter,type,amount,extra,time)

    @transactions[id] << txn

    @txn_counter += 1

  end




  def create_customer(name,email,phone,address)

    Validator.name(name)
    Validator.email(email)
    Validator.phone(phone)
    Validator.address(address)

    Validator.duplicate_email(@customers,email)
    Validator.duplicate_phone(@customers,phone)

    id=@customers.empty? ? 1 : @customers.keys.max+1

    @customers[id] = Customer.new(id,name,email,phone,address)
    @accounts[id] = Account.new

    puts "Customer created. ID=#{id}"

  end



  def deposit(id,amount)

    Validator.customer_exists(@customers,id)
    Validator.amount(amount)

    authenticate(id)

    add_balance(id,amount)

    record_transaction(id,:deposit,amount)

    puts "Deposit successful"
    puts "Balance=#{@accounts[id].balance}"

  end



  def withdraw(id,amount)

    Validator.customer_exists(@customers,id)
    Validator.amount(amount)

    authenticate(id)

    deduct_balance(id,amount)

    record_transaction(id,:withdraw,amount)

    puts "Withdraw successful"

  end



  def transfer(from,to,amount)

    Validator.customer_exists(@customers,from)
    Validator.customer_exists(@customers,to)
    Validator.amount(amount)

    authenticate(from)

    deduct_balance(from,amount)
    add_balance(to,amount)

    time = Time.now

    record_transaction(from,:transfer_sent,amount,{to:to},time)
    record_transaction(to,:transfer_received,amount,{from:from},time)

    puts "Transfer successful"

  end



  def approve_loan(id,amount,years)

    Validator.customer_exists(@customers,id)
    Validator.amount(amount)

    authenticate(id)

    loan = Loan.new(id,amount,years)

    add_balance(id,amount)
    @accounts[id].loan_amount += amount

    @loans[@loan_counter] = loan

    record_transaction(id,:loan_taken,amount)

    puts "Loan approved"
    puts "EMI=#{loan.emi}"
    puts "Due date=#{loan.due_date}"

    @loan_counter += 1

  end



  def repay_loan(id,amount)

    Validator.customer_exists(@customers,id)
    Validator.amount(amount)

    authenticate(id)

    loans = @loans.select{|k,v| v.customer_id==id}

    raise "No loan found" if loans.empty?

    loan_id,loan = loans.first

    deduct_balance(id,amount)

    loan.remaining -= amount

    if loan.remaining <= 0
      loan.remaining = 0
      loan.status = :paid
      puts "Loan fully repaid"
    else
      puts "Remaining loan #{loan.remaining}"
    end

    record_transaction(id,:loan_repayment,amount)

  end



  def show_customer(id)

    Validator.customer_exists(@customers,id)

    authenticate(id)

    c=@customers[id]
    a=@accounts[id]

    puts "Name: #{c.name}"
    puts "Email: #{c.email}"
    puts "Phone: #{c.phone}"
    puts "Address: #{c.address}"
    puts "Balance: #{a.balance}"
    puts "Loan: #{a.loan_amount}"

  end



  def show_transactions(id)

    Validator.customer_exists(@customers,id)

    if @transactions[id].empty?
      puts "No transactions"
      return
    end

    @transactions[id].each do |t|
      puts "#{t.txn_id} | #{t.type} | #{t.amount} | #{t.time}"
    end

  end



  def show_loans(id)

    Validator.customer_exists(@customers,id)

    loans=@loans.select{|k,v| v.customer_id==id}

    if loans.empty?
      puts "No loans"
      return
    end

    loans.each do |lid,l|
      puts "Loan ID #{lid} | Amount #{l.loan_amount} | EMI #{l.emi} | Remaining #{l.remaining} | Due #{l.due_date}"
    end

  end



  def maximum_transaction

    raise "No transactions" if @transactions.empty?

    max_customer=nil
    max_amount=0

    @transactions.each do |id,txns|

      total=txns.sum{|t| t.amount}

      if total>max_amount
        max_amount=total
        max_customer=id
      end

    end

    puts "Customer ID #{max_customer} | Transaction Amount #{max_amount}"

  end



  def fraud_customer

    raise "No loans found" if @loans.empty?

    @loans.values
    .group_by{|l| l.customer_id}
    .each do |id,loans|

      total=loans.sum{|l| l.loan_amount}
      balance=@accounts[id].balance

      if balance<total
        puts "Fraud Risk Customer #{id} | Balance #{balance} | Loan #{total}"
      end

    end

  end



  def transactions_between(id1,id2)

    found=false

    [id1,id2].each do |id|

      @transactions[id].each do |t|

        if t.type==:transfer_sent

          from=id
          to=t.details[:to]

          if (from==id1 && to==id2) || (from==id2 && to==id1)

            puts "From #{from} -> To #{to} | Amount #{t.amount} | Time #{t.time}"
            found=true

          end

        end

      end

    end

    puts "No transactions between #{id1} and #{id2}" unless found

  end

end

end