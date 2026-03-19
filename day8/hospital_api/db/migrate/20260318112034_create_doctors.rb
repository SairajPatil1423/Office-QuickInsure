class CreateDoctors < ActiveRecord::Migration[7.1]
  def change
    create_table :doctors, id: :uuid do |t|
      t.string :name, null: false
      t.string :specialization
      t.string :phone
      t.string :email
      t.decimal :salary, precision: 10, scale: 2
      t.string :status


      t.references :department, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
