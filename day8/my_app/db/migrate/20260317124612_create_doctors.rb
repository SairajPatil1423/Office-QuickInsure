class CreateDoctors < ActiveRecord::Migration[7.1]
  def change
    create_table :doctors do |t|
      t.string :name
      t.string :specialization
      t.string :phone
      t.string :email
      t.decimal :salary
      t.string :status
      t.references :department, null: false, foreign_key: true

      t.timestamps
    end
  end
end
