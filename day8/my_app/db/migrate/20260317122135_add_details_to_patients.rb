class AddDetailsToPatients < ActiveRecord::Migration[7.1]
  def change
    add_column :patients, :dob, :date
    add_column :patients, :gender, :string
    add_column :patients, :email, :string
    add_column :patients, :address, :text
    add_column :patients, :blood_group, :string
    add_column :patients, :registration_date, :date
  end
end
