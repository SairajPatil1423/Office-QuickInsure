class AddSchedulingToDoctors < ActiveRecord::Migration[7.1]
  def change
    add_column :doctors, :start_time, :time
    add_column :doctors, :end_time, :time
    add_column :doctors, :slot_duration, :integer, default: 30
  end
end
