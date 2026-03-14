# frozen_string_literal: true

require_relative 'bank'

bank = Bank.new

def ask(text)
  print "#{text}: "
  gets.chomp.strip
end

def ask_i(text)
  print "#{text}: "
  input = gets.chomp.strip
  raise "Invalid input — expected number for '#{text}'" unless input.match?(/\A\d+\z/)

  input.to_i
end

loop do
  puts
  puts '******* BANK SYSTEM *******'
  puts '1. User Panel'
  puts '2. Admin Panel'
  puts '3. Exit'

  choice = begin
    ask_i('Enter choice')
  rescue StandardError
    (puts 'Invalid input'
     next)
  end

  case choice

  when 1
    loop do
      puts
      puts '---- USER PANEL ----'
      puts '1. Create Customer'
      puts '2. Deposit'
      puts '3. Withdraw'
      puts '4. Transfer'
      puts '5. Take Loan'
      puts '6. Pay Monthly EMI'
      puts '7. Flexible Loan Payment'
      puts '8. Show Customer'
      puts '9. Show Transactions'
      puts '10. Back'

      c = begin
        ask_i('Enter choice')
      rescue StandardError
        (puts 'Invalid input'
         next)
      end

      begin
        case c

        when 1
          bank.create_customer(
            ask('Name'),
            ask('Email'),
            ask('Phone'),
            ask('Address'),
            ask('Password')
          )

        when 2
          bank.deposit(
            ask_i('Customer ID'),
            ask_i('Amount')
          )

        when 3
          bank.withdraw(
            ask_i('Customer ID'),
            ask_i('Amount')
          )

        when 4
          bank.transfer(
            ask_i('Sender ID'),
            ask_i('Receiver ID'),
            ask_i('Amount')
          )

        when 5
          bank.approve_loan(
            ask_i('Customer ID'),
            ask_i('Loan Amount'),
            ask_i('Years')
          )

        when 6
          bank.pay_monthly_emi(
            ask_i('Customer ID')
          )

        when 7
          bank.flexible_loan_payment(
            ask_i('Customer ID'),
            ask_i('Payment Amount')
          )

        when 8
          bank.show_customer(
            ask_i('Customer ID')
          )

        when 9
          bank.show_transactions(
            ask_i('Customer ID')
          )

        when 10
          break

        else
          puts 'Invalid choice'

        end
      rescue StandardError => e
        puts "Error: #{e.message}"
      end
    end

  when 2
    begin
      bank.admin_auth
    rescue StandardError => e
      puts "Error: #{e.message}"
      next
    end

    loop do
      puts
      puts '---- ADMIN PANEL ----'
      puts '1. View Customers'
      puts '2. Unlock Locked Accounts'
      puts '3. Show Frozen Accounts'
      puts '4. Freeze Account'
      puts '5. Unfreeze Account'
      puts '6. Close Account'
      puts '7. Delete Customer'
      puts '8. View Customer Transactions'
      puts '9. Back'

      c = begin
        ask_i('Enter choice')
      rescue StandardError
        (puts 'Invalid input'
         next)
      end

      begin
        case c

        when 1
          bank.view_customers

        when 2
          bank.show_locked_accounts
          bank.unlock_account(
            ask_i('Enter ID to unlock')
          )

        when 3
          bank.show_frozen_accounts

        when 4
          bank.freeze_account(
            ask_i('Customer ID')
          )

        when 5
          bank.unfreeze_account(
            ask_i('Customer ID')
          )

        when 6
          bank.close_account(
            ask_i('Customer ID')
          )

        when 7
          bank.delete_customer(
            ask_i('Customer ID')
          )

        when 8
          bank.show_transactions(
            ask_i('Customer ID')
          )

        when 9
          break

        else
          puts 'Invalid choice'

        end
      rescue StandardError => e
        puts "Error: #{e.message}"
      end
    end

  when 3
    puts 'Goodbye'
    break

  else
    puts 'Invalid choice'

  end
end
