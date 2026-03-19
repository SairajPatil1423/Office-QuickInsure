class Bill < ApplicationRecord
  belongs_to :patient

  validates :total_amount, presence: true

  def self.generate_bill(patient_id)
    patient = Patient.find_by(id: patient_id)
    return { error: "Patient not found" } unless patient

    admission = patient.admissions.where(discharge_date: nil).last
    return { error: "No active admission found" } unless admission

    
    days = (Date.today - admission.admission_date).to_i
    days = 1 if days == 0

    
    consultation_fee = 500
    bed_charge_per_day = 2000

    total = consultation_fee + (days * bed_charge_per_day)

    bill = create(
      patient_id: patient.id,
      total_amount: total,
      payment_status: "pending",
      payment_date: nil
    )

    { bill: bill }
  end
end