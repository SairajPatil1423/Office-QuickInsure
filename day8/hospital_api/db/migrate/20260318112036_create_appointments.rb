class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments, id: :uuid do |t|
      t.references :patient, type: :uuid, null: false, foreign_key: true
      t.references :doctor, type: :uuid, null: false, foreign_key: true

      t.date :apt_date
      t.time :apt_time
      t.string :status

      t.timestamps
    end
  end
end
