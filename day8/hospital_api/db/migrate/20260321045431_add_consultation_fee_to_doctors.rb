class AddConsultationFeeToDoctors < ActiveRecord::Migration[7.1]
  def change
    add_column :doctors, :consultation_fee, :decimal, default: 500
  end
end
