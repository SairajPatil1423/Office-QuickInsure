class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms, id: :uuid do |t|
  t.references :ward, type: :uuid, null: false, foreign_key: true

  t.string :room_number
  t.string :room_type

  t.timestamps
end
  end
end
