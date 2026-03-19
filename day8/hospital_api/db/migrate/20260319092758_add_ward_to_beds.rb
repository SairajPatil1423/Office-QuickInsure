class AddWardToBeds < ActiveRecord::Migration[7.1]
  def change
    add_reference :beds, :ward, type: :uuid, foreign_key: true
  end
end
