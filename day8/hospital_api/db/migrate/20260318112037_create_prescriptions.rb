class CreatePrescriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :prescriptions, id: :uuid do |t|
      t.references :patient, type: :uuid, null: false, foreign_key: true
      t.references :doctor, type: :uuid, null: false, foreign_key: true

      t.date :date
      t.text :diagnosis
      t.text :notes

      t.timestamps
    end
  end
end