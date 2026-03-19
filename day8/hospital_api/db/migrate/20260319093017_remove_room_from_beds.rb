class RemoveRoomFromBeds < ActiveRecord::Migration[7.1]
  def change
    remove_reference :beds, :room, null: false, foreign_key: true
  end
end
