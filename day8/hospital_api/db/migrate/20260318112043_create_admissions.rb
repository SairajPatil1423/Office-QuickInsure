class CreateAdmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :admissions, id: :uuid do |t|
      t.references :patient, type: :uuid, null: false, foreign_key: true
      t.references :bed, type: :uuid, null: false, foreign_key: true

      t.date :admission_date
      t.date :discharge_date

      t.timestamps
    end
  end
end