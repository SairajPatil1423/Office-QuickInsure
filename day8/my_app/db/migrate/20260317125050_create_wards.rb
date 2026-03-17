class CreateWards < ActiveRecord::Migration[7.1]
  def change
    create_table :wards do |t|
      t.string :ward_name
      t.string :ward_type
      t.integer :capacity

      t.timestamps
    end
  end
end
