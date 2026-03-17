# frozen_string_literal: true

require 'uri'

class Validator
  MIN_PASSWORD_LENGTH = 4
  MAX_NAME_LENGTH     = 50
  MAX_ADDRESS_LENGTH  = 100

  def self.customer_exists(customers, id)
    raise 'Customer not found' unless customers[id]
  end

  def self.amount(amount)
    raise 'Amount must be a number'       unless amount.is_a?(Numeric)
    raise 'Amount must be greater than 0' if amount <= 0
    raise 'Amount is too large'           if amount > 10_000_000
  end

  def self.name(name)
    name = name.to_s.strip
    raise 'Name cannot be blank' if name.empty?
    raise "Name must be at most #{MAX_NAME_LENGTH} characters" if name.length > MAX_NAME_LENGTH
    raise 'Invalid name. Only letters, spaces or hyphens allowed' unless name.match?(/\A[a-zA-Z][a-zA-Z\s-]{1,}\z/)
  end

  def self.email(email)
    email = email.to_s.strip
    raise 'Email cannot be blank' if email.empty?
    raise 'Invalid email format'  unless email.match?(URI::MailTo::EMAIL_REGEXP)
  end

  def self.phone(phone)
    phone = phone.to_s.strip
    raise 'Phone cannot be blank'  if phone.empty?
    raise 'Invalid phone number'   unless phone.match?(/\A[6-9]\d{9}\z/)
  end

  def self.address(address)
    address = address.to_s.strip
    raise 'Address cannot be blank'                                  if address.empty?
    raise 'Address too short'                                        if address.length < 5
    raise "Address must be at most #{MAX_ADDRESS_LENGTH} characters" if address.length > MAX_ADDRESS_LENGTH
    raise 'Invalid address characters'                               unless address.match?(%r{\A[a-zA-Z0-9\s,.\-/]+\z})
  end

  def self.password(password)
    raise "Password must be at least #{MIN_PASSWORD_LENGTH} characters" if password.to_s.length < MIN_PASSWORD_LENGTH
  end

  def self.loan_years(years)
    raise 'Loan duration must be at least 1 year'  if years < 1
    raise 'Loan duration cannot exceed 30 years'   if years > 30
  end

  def self.duplicate_email(customers, email)
    exists = customers.values.any? { |c| c.email.downcase == email.downcase.strip }
    raise 'Email already registered' if exists
  end

  def self.duplicate_phone(customers, phone)
    exists = customers.values.any? { |c| c.phone == phone.to_s.strip }
    raise 'Phone already registered' if exists
  end
end
