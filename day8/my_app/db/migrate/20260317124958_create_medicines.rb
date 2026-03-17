class CreateMedicines < ActiveRecord::Migration[7.1]
  def change
    create_table :medicines do |t|
      t.string :name
      t.decimal :price
      t.integer :stock_qty
      t.date :expiry_date

      t.timestamps
    end
  end
end
