INTEREST = 0.10
PERIOD = 12.0

$customers = {
  1 => {name: "sairaj", email: "sai@mail.com", phone: "9876543210", address: "Karad"},
  2 => {name: "Amit",  email: "amit@mail.com",  phone: "9123456789", address: "Pune"},
  3 => {name: "Sidharth",  email: "sid@mail.com",  phone: "9988776655", address: "Mumbai"}
}

$accounts = {
  1 => {balance: 15000, loan_amount: 50000},
  2 => {balance: 22000, loan_amount: 0},
  3 => {balance: 8000,  loan_amount: 20000}
}

$transactions = {
  1 => [
    {txn_id: 1, type: :deposit, amount: 15000, time: Time.now, details: {}},
    {txn_id: 4, type: :deposit, amount: 15000, time: Time.now, details: {}}
  ],
  2 => [
    {txn_id: 2, type: :deposit, amount: 22000, time: Time.now, details: {}}
  ],
  3 => [
    {txn_id: 3, type: :deposit, amount: 8000, time: Time.now, details: {}}
  ]
}

$loans = {
  1 => {customer_id: 1, loan_amount: 50000, status: :approved, emi: 4583.33},
  2 => {customer_id: 3, loan_amount: 20000, status: :approved, emi: 1833.33}
}

txn_counter = 4
loan_counter = 3

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

def display_loans(customer_id)
  validate_customer(customer_id)

  loans = $loans.select { |loan_id, loan| loan[:customer_id] == customer_id }

  if loans.empty?
    puts "No loans found"
    return
  end

  loans.each do |loan_id, loan|
    puts "Loan ID: #{loan_id} | Amount: #{loan[:loan_amount]} | EMI: #{loan[:emi]} | Status: #{loan[:status]}"
  end
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

# Queries  ->cust with max transaction by amount
def maximum_transaction
  raise "No transactions found" if $transactions.empty?

  max_customer = nil
  max_amount = 0

  $transactions.each do |customer_id, txns|
    total = txns.sum { |t| t[:amount] }

    if total > max_amount
      max_amount = total
      max_customer = customer_id
    end
  end

  puts "Customer ID: #{max_customer} | Transaction Amount: #{max_amount}"
end

# customer who has balance<loan he withdrawn amount
def fraud_customer
  raise "No loans found" if $loans.empty?

  $loans.values
        .group_by { |l| l[:customer_id] }
        .each do |customer_id, loans|

    total_loan = loans.sum { |l| l[:loan_amount] }
    balance = $accounts[customer_id][:balance]

    if balance < total_loan
      puts "Fraud Risk Customer ID: #{customer_id} | Balance: #{balance} | Total Loan: #{total_loan}"
    end
  end
end

#transaction between two users
def transactions_between(id1, id2)
  found = false

  [$transactions[id1], $transactions[id2]].each do |txns|
    txns.each do |t|
      if t[:type] == :transfer_sent
        from = t[:details][:from] 
        to = t[:details][:to]

        if (from == id1 && to == id2) || (from == id2 && to == id1)
          puts "From #{from} → To #{to} | Amount: #{t[:amount]} | Time: #{t[:time]}"
          found = true
        end
      end
    end
  end

  puts "No transactions between #{id1} and #{id2}" unless found
end

while true
  puts "1 Create Customer"
  puts "2 Deposit"
  puts "3 Withdraw"
  puts "4 Transfer"
  puts "5 Loan"
  puts "6 Balance"
  puts "7 Transactions"
  puts "8 Customer Details"
  puts "9 Show Loans"
  puts "10 max transaction User"
  puts "11 Exit"

  choice = gets.chomp.to_i
  break if choice == 11

  attempts = 0

  begin
    if choice != 1 && choice!=10
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
    when 9
      display_loans(id)
    when 10
      maximum_transaction()
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