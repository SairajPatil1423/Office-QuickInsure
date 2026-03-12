require_relative 'bank_system'

bank = Bank_System::Bank.new

loop do

  puts "****** BANK MENU ******"
  puts "1 Add Account"
  puts "2 Deposit"
  puts "3 Withdraw"
  puts "4 Transfer"
  puts "5 Take Loan"
  puts "6 Show Customer"
  puts "7 Show Transactions"
  puts "8 Exit"

  print "Enter choice: "
  choice = gets.chomp.to_i

  begin

    case choice

    when 1
      print "Name: "
      name = gets.chomp

      print "Email: "
      email = gets.chomp

      print "Phone: "
      phone = gets.chomp

      print "Address: "
      address = gets.chomp

      bank.add_account(name,email,phone,address)

    when 2
      print "Customer ID: "
      id = gets.chomp.to_i

      print "Amount: "
      amt = gets.chomp.to_i

      bank.deposit(id,amt)


    when 3
      print "Customer ID: "
      id = gets.chomp.to_i

      print "Amount: "
      amt = gets.chomp.to_i

      bank.withdraw(id,amt)


    when 4
      print "Sender ID: "
      from = gets.chomp.to_i

      print "Receiver ID: "
      to = gets.chomp.to_i

      print "Amount: "
      amt = gets.chomp.to_i

      bank.transfer(from,to,amt)


    when 5
      print "Customer ID: "
      id = gets.chomp.to_i

      print "Loan Amount: "
      amt = gets.chomp.to_i

      bank.take_loan(id,amt)


    when 6
      print "Customer ID: "
      id = gets.chomp.to_i

      bank.show_customer(id)


    when 7
      bank.show_transactions


    when 8
      puts "Exiting..."
      break

    else
      puts "Invalid choice"

    end

  rescue => e
    puts "Error: #{e.message}"
  end

end