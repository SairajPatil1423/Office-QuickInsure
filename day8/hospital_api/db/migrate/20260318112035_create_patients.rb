class CreatePatients < ActiveRecord::Migration[7.1]
  def change
    create_table :patients, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.date :dob
      t.string :gender
      t.string :email
      t.text :address
      t.string :blood_group
      t.date :registration_date

    t.timestamps
  end
  end
end
