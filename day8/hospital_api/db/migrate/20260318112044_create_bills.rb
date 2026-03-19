class CreateBills < ActiveRecord::Migration[7.1]
  def change
    create_table :bills, id: :uuid do |t|
  t.references :patient, type: :uuid, null: false, foreign_key: true

  t.decimal :total_amount
  t.string :payment_status
  t.date :payment_date

  t.timestamps
end
  end
end
