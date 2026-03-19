class AddDurationToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_column :appointments, :duration, :integer, null: false, default: 30
  end
end
