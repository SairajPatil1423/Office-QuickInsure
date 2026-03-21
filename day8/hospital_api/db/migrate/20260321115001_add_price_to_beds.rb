class AddPriceToBeds < ActiveRecord::Migration[7.1]
  def change
    add_column :beds, :price_per_day, :decimal
  end
end
