class Transaction

  attr_reader :txn_id, :type, :amount, :balance_after, :details, :time

  def initialize(txn_id, type, amount, balance_after, details = {}, time = nil)

    @txn_id = txn_id
    @type = type
    @amount = amount
    @balance_after = balance_after
    @details = details

    @time = time || Time.now

  end

end