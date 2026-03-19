class CreatePrescriptionMedicines < ActiveRecord::Migration[7.1]
  def change
    create_table :prescription_medicines, id: :uuid do |t|
        t.references :prescription, type: :uuid, null: false, foreign_key: true
        t.references :medicine, type: :uuid, null: false, foreign_key: true

        t.string :dosage
        t.string :duration

        t.timestamps
    end
  end
end
