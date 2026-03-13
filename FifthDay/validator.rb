class Validator

  def self.customer_exists(customers, id)
    raise "Customer not found" unless customers[id]
  end


  def self.amount(amount)
    raise "Amount must be greater than 0" if amount <= 0
  end


  def self.name(name)

    unless name.match?(/\A[a-zA-Z\s\-]{3,50}\z/)
      raise "Invalid name. Only alphabets, spaces or hyphens allowed"
    end

  end


  def self.email(email)

    unless email.match?(URI::MailTo::EMAIL_REGEXP)
      raise "Invalid email format"
    end

  end


  def self.phone(phone)

    unless phone.match?(/\A[6-9]\d{9}\z/)
      raise "Invalid phone number"
    end

  end


  def self.address(address)

    unless address.match?(/\A[a-zA-Z0-9\s,\-]{5,100}\z/)
      raise "Invalid address"
    end

  end


  def self.duplicate_email(customers, email)

    exists = customers.values.any? do |customer|
      customer.email.downcase == email.downcase
    end

    raise "Email already registered" if exists

  end


  def self.duplicate_phone(customers, phone)

    exists = customers.values.any? do |customer|
      customer.phone == phone
    end

    raise "Phone already registered" if exists

  end

end