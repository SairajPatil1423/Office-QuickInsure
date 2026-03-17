# frozen_string_literal: true

class Loan
  attr_accessor :remaining_balance, :status, :last_payment_date
  attr_reader :loan_id, :customer_id, :principal, :rate, :years, :start_date, :emi

  def initialize(loan_id, customer_id, amount, years, rate = 0.10)
    @loan_id = loan_id
    @customer_id = customer_id
    @principal = amount
    @rate = rate
    @years = years
    @start_date = Time.now
    @last_payment_date = @start_date
    total_interest = amount * rate * years
    total_payable = amount + total_interest
    months = years * 12
    @emi = (total_payable / months.to_f).round(2)
    @remaining_balance = total_payable
    @status = :active
  end
end
