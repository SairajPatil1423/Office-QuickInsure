INTEREST = 0.10
PERIOD = 12.0

$customers = {}
$accounts = {}
$transactions = {}
$loans = {}

txn_counter = 1
loan_counter = 1

def validate_customer(customer_id)
  raise "Customer not found" unless $customers[customer_id]
end

def validate_amount(amount)
  raise "Invalid amount" if amount <= 0
end

def validate_email(email)
  raise "Invalid email" unless email.match?(/\A.+@.+\..+\z/)
end

def validate_phone(phone)
  raise "Invalid phone" unless phone.match?(/^\d{10}$/)
end

def validate_name(name)
  raise "Name must contain only alphabets" unless name.match?(/\A[a-zA-Z]+\z/)
  raise "Name must be longer than 3 characters" unless name.length > 3
end

def validate_address(address)
  raise "Address must contain only alphabets" unless address.match?(/\A[a-zA-Z]+\z/)
  raise "Address must be longer than 3 characters" unless address.length > 3
end

def check_duplicate_email(email)
  exists = $customers.values.any? { |c| c[:email].downcase == email.downcase }
  raise "Email already registered" if exists
end

def check_duplicate_phone(phone)
  exists = $customers.values.any? { |c| c[:phone] == phone }
  raise "Phone already registered" if exists
end

emi_calc = ->(loan_amount) do
  total = loan_amount + (loan_amount * INTEREST)
  (total / PERIOD).round(2)
end

def record_transaction(customer_id, type, amount, counter, extra = {}, time = Time.now)
  $transactions[customer_id] ||= []
  $transactions[customer_id] << {
    txn_id: counter,
    type: type,
    amount: amount,
    time: time,
    details: extra
  }
end

def create_customer
  puts "Name:"
  name = gets.chomp
  validate_name(name)

  puts "Email:"
  email = gets.chomp
  validate_email(email)
  check_duplicate_email(email)

  puts "Phone:"
  phone = gets.chomp
  validate_phone(phone)
  check_duplicate_phone(phone)

  puts "Address:"
  address = gets.chomp
  validate_address(address)

  id = $customers.empty? ? 1 : $customers.keys.max + 1

  $customers[id] = {
    name: name,
    email: email,
    phone: phone,
    address: address
  }

  $accounts[id] = {
    balance: 0,
    loan_amount: 0
  }

  puts "Customer created. ID = #{id}"
end

def deposit_money(customer_id, counter)
  validate_customer(customer_id)

  puts "Amount:"
  amount = gets.chomp.to_i
  validate_amount(amount)

  $accounts[customer_id][:balance] += amount

  record_transaction(customer_id, :deposit, amount, counter)

  puts "Deposit successful"
  puts "Balance = #{$accounts[customer_id][:balance]}"
end

def withdraw_money(customer_id, counter)
  validate_customer(customer_id)

  puts "Amount:"
  amount = gets.chomp.to_i
  validate_amount(amount)

  raise "Insufficient balance" if $accounts[customer_id][:balance] < amount

  $accounts[customer_id][:balance] -= amount

  record_transaction(customer_id, :withdraw, amount, counter)

  puts "Withdraw successful"
end

def transfer_money(customer_id, counter)
  validate_customer(customer_id)

  puts "Receiver ID:"
  receiver_id = gets.chomp.to_i
  validate_customer(receiver_id)

  puts "Amount:"
  amount = gets.chomp.to_i
  validate_amount(amount)

  raise "Insufficient balance" if $accounts[customer_id][:balance] < amount

  $accounts[customer_id][:balance] -= amount
  $accounts[receiver_id][:balance] += amount

  time = Time.now

  record_transaction(customer_id, :transfer_sent, amount, counter, {to: receiver_id}, time)
  record_transaction(receiver_id, :transfer_received, amount, counter, {from: customer_id}, time)

  puts "Transfer successful"
end

def approve_loan(customer_id, loan_counter, emi_calc)
  validate_customer(customer_id)

  puts "Loan Amount:"
  amount = gets.chomp.to_i
  validate_amount(amount)

  emi = emi_calc.call(amount)

  $accounts[customer_id][:loan_amount] += amount
  $accounts[customer_id][:balance] += amount

  $loans[loan_counter] = {
    customer_id: customer_id,
    loan_amount: amount,
    status: :approved,
    emi: emi
  }

  puts "Loan approved"
  puts "EMI = #{emi}"
end

def display_transactions(customer_id)
  validate_customer(customer_id)

  if $transactions[customer_id].nil?
    puts "No transactions"
    return
  end

  $transactions[customer_id].each do |txn|
    puts "#{txn[:txn_id]} | #{txn[:type]} | #{txn[:amount]} | #{txn[:time]}"
  end
end

def display_customer(customer_id)
  validate_customer(customer_id)

  customer = $customers[customer_id]
  account = $accounts[customer_id]

  puts "Name: #{customer[:name]}"
  puts "Email: #{customer[:email]}"
  puts "Phone: #{customer[:phone]}"
  puts "Address: #{customer[:address]}"
  puts "Balance: #{account[:balance]}"
  puts "Loan: #{account[:loan_amount]}"
end

while true
  puts "\n------ BANK MENU ------"
  puts "1 Create Customer"
  puts "2 Deposit"
  puts "3 Withdraw"
  puts "4 Transfer"
  puts "5 Loan"
  puts "6 Balance"
  puts "7 Transactions"
  puts "8 Customer Details"
  puts "9 Exit"

  choice = gets.chomp.to_i
  break if choice == 9

  attempts = 0

  begin
    if choice != 1
      puts "Customer ID:"
      id = gets.chomp.to_i
    end

    case choice
    when 1
      create_customer

    when 2
      deposit_money(id, txn_counter)
      txn_counter += 1

    when 3
      withdraw_money(id, txn_counter)
      txn_counter += 1

    when 4
      transfer_money(id, txn_counter)
      txn_counter += 1

    when 5
      approve_loan(id, loan_counter, emi_calc)
      loan_counter += 1

    when 6
      puts "Balance = #{$accounts[id][:balance]}"

    when 7
      display_transactions(id)

    when 8
      display_customer(id)

    else
      puts "Invalid choice"
    end

  rescue => e
    attempts += 1
    puts "Error: #{e.message}"

    if attempts < 3
      puts "Try again (#{3 - attempts} attempts left)"
      retry
    else
      puts "Too many invalid attempts. Returning to menu."
    end
  end
end