class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :doctor, null: false, foreign_key: true
      t.date :apt_date
      t.time :apt_time
      t.string :status

      t.timestamps
    end
  end
end
