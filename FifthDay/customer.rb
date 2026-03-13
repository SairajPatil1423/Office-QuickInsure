# frozen_string_literal: true

class Customer
  attr_reader :id, :name, :email, :phone, :address, :created_at
  attr_accessor :role, :status

  def initialize(id, name, email, phone, address, role = :user)
    @id = id
    @name = name
    @email = email
    @phone = phone
    @address = address

    @role = role
    @status = :active

    @created_at = Time.now
  end
end
