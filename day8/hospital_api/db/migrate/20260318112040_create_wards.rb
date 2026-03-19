class CreateWards < ActiveRecord::Migration[7.1]
  def change
    create_table :wards, id: :uuid do |t|
      t.string :ward_name
      t.string :ward_type
      t.integer :capacity

      t.timestamps
    end
  end
end
