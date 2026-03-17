# frozen_string_literal: true

class Account
  attr_accessor :balance, :password, :failed_attempts, :locked, :loan_total

  def initialize(password)
    @balance = 0
    @password = password

    @failed_attempts = 0
    @locked = false

    @loan_total = 0
  end
end
