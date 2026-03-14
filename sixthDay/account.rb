# frozen_string_literal: true

require 'digest'

class Account
  attr_accessor :balance, :failed_attempts, :locked, :loan_total
  attr_reader :password_hash

  def initialize(password)
    @balance = 0
    @password_hash = hash_password(password)
    @failed_attempts = 0
    @locked = false
    @loan_total = 0
  end

  def correct_password?(input)
    @password_hash == hash_password(input)
  end

  def change_password(new_password)
    raise 'Password must be at least 4 characters' if new_password.length < 4

    @password_hash = hash_password(new_password)
  end

  private

  def hash_password(password)
    Digest::SHA256.hexdigest(password)
  end
end
