INTEREST = 0.10
PERIOD = 12.0

$customers = {}
$accounts = {}
$transactions = {}
$loans = {}

txn_counter = 1
loan_counter = 1


def validate_customer(id)
  raise "Customer not found" unless $customers[id]
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


emi_calc = ->(loan) do
  total = loan + (loan * INTEREST)
  (total / PERIOD).round(2)
end

def add_transaction(id,type,amount,counter,extra={},time=Time.now)

  $transactions[id] ||= []

  $transactions[id] << {
    txn_id: counter,
    type: type,
    amount: amount,
    time:time,
    details: extra
  }

end

def add_customer()

  puts "Name:"
  name = gets.chomp
  raise "Invalid name" if name.length < 3

  puts "Email:"
  email = gets.chomp
  validate_email(email)

  puts "Phone:"
  phone = gets.chomp
  validate_phone(phone)

  puts "Address:"
  address = gets.chomp

  id = $customers.empty? ? 1 : $customers.keys.max + 1

  $customers[id] = {
    name:name,
    email:email,
    phone:phone,
    address:address
  }

  $accounts[id] = {
    balance:0,
    loan_amount:0
  }

  puts "Customer created ID = #{id}"

end

def deposit(id,counter)

  validate_customer(id)

  puts "Amount:"
  amt = gets.chomp.to_i
  validate_amount(amt)

  $accounts[id][:balance] += amt

  add_transaction(id,"Deposit",amt,counter)

  puts "Deposit successful"
  puts "Balance = #{$accounts[id][:balance]}"

end

def withdraw(id,counter)

  validate_customer(id)

  puts "Amount:"
  amt = gets.chomp.to_i
  validate_amount(amt)

  raise "Insufficient balance" if $accounts[id][:balance] < amt

  $accounts[id][:balance] -= amt

  add_transaction(id,"Withdraw",amt,counter)

  puts "Withdraw successful"

end

def transfer(id,counter)

  validate_customer(id)

  puts "Receiver ID:"
  to = gets.chomp.to_i
  validate_customer(to)

  puts "Amount:"
  amt = gets.chomp.to_i
  validate_amount(amt)

  raise "Insufficient balance" if $accounts[id][:balance] < amt

  $accounts[id][:balance] -= amt
  $accounts[to][:balance] += amt
  time=Time.now
  add_transaction(id,"Transfer Sent",amt,counter,{to:to},time)
  add_transaction(to,"Transfer Received",amt,counter,{from:id},time)

  puts "Transfer successful"

end

def loan(id,loan_counter,emi_calc)

  validate_customer(id)

  puts "Loan Amount:"
  amt = gets.chomp.to_i
  validate_amount(amt)

  emi = emi_calc.call(amt)

  $accounts[id][:loan_amount] += amt
  $accounts[id][:balance] += amt

  $loans[loan_counter] = {
    customer_id:id,
    loan_amount:amt,
    status:"approved",
    emi:emi
  }

  puts "Loan approved"
  puts "EMI = #{emi}"

end

def show_transactions(id)
  validate_customer(id)
  if $transactions[id].nil?
    puts "No $transactions"
    return
  end

  $transactions[id].each do |t|
    puts "#{t[:txn_id]} | #{t[:type]} | #{t[:amount]} | #{t[:time]}"
  end

end

def show_customer(id)

  validate_customer(id)

  c = $customers[id]
  a = $accounts[id]

  puts "Name: #{c[:name]}"
  puts "Email: #{c[:email]}"
  puts "Phone: #{c[:phone]}"
  puts "Address: #{c[:address]}"
  puts "Balance: #{a[:balance]}"
  puts "Loan: #{a[:loan_amount]}"

end

while true

  puts "\n------ BANK MENU ------"
  puts "1 Add Customer"
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
      add_customer()

    when 2
      deposit(id,txn_counter)
      txn_counter += 1

    when 3
      withdraw(id,txn_counter)
      txn_counter += 1

    when 4
      transfer(id,txn_counter)
      txn_counter += 1

    when 5
      loan(id,loan_counter,emi_calc)
      loan_counter += 1

    when 6
      puts "Balance = #{$accounts[id][:balance]}"

    when 7
      show_transactions(id)

    when 8
      show_customer(id)

    else
      puts "Invalid choice"

    end

  rescue => e
    attempts += 1
    puts "Error: #{e.message}"

    if attempts < 3
      puts "Try again (#{3-attempts} attempts left)"
      retry
    else
      puts "Too many invalid attempts. Returning to menu."
    end
  end

end