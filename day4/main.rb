require_relative "Bank_System"

bank = BankSystem::Bank.new

def ask(text)
  print "#{text}: "
  gets.chomp
end

def ask_i(text)
  print "#{text}: "
  gets.chomp.to_i
end

while true
  
  puts
  puts "1 Create Customer"
  puts "2 Deposit"
  puts "3 Withdraw"
  puts "4 Transfer"
  puts "5 Take Loan"
  puts "6 Repay Loan"
  puts "7 Show Customer Details"
  puts "8 Show Transactions"
  puts "9 Show Loans"
  puts "10 Max Transaction Customer"
  puts "11 Fraud Customers"
  puts "12 Transactions Between Two Customers"
  puts "13 Exit"

  attempts = 0
  choice = ask_i("Enter choice")

  begin

    case choice

    when 1
      bank.create_customer(
        ask("Name"),
        ask("Email"),
        ask("Phone"),
        ask("Address"),
        ask("Password")
      )

    when 2
      bank.deposit(
        ask_i("Customer ID"),
        ask_i("Amount")
      )

    when 3
      bank.withdraw(
        ask_i("Customer ID"),
        ask_i("Amount")
      )

    when 4
      bank.transfer(
        ask_i("Sender ID"),
        ask_i("Receiver ID"),
        ask_i("Amount")
      )

    when 5
      bank.approve_loan(
        ask_i("Customer ID"),
        ask_i("Loan Amount"),
        ask_i("Loan Years")
      )

    when 6
      bank.repay_loan(
        ask_i("Customer ID"),
        ask_i("Repay Amount")
      )

    when 7
      bank.show_customer(
        ask_i("Customer ID")
      )

    when 8
      bank.show_transactions(
        ask_i("Customer ID")
      )

    when 9
      bank.show_loans(
        ask_i("Customer ID")
      )

    when 10
      bank.maximum_transaction

    when 11
      bank.fraud_customer

    when 12
      bank.transactions_between(
        ask_i("Customer 1 ID"),
        ask_i("Customer 2 ID")
      )

    when 13
      break

    else
      puts "Invalid choice"

    end

  rescue => e
    attempts += 1
    puts e.message
    retry if attempts < 3
  end

end