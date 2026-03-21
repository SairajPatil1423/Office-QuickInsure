class Bill < ApplicationRecord
  belongs_to :patient

  def self.generate(patient_id)
    patient = Patient.find_by(id: patient_id)
    return { error: "Patient not found" } unless patient

    admission = patient.admissions.where.not(discharge_date: nil).last
    return { error: "No completed admission" } unless admission

    bed = admission.bed

    days = (admission.discharge_date - admission.admission_date).to_i
    days = 1 if days <= 0

    bed_charges = days * bed.price_per_day

    doctor_fee = patient.appointments.last&.doctor&.consultation_fee || 0

    total = bed_charges + doctor_fee

    bill = create(
      patient_id: patient.id,
      total_amount: total,
      payment_status: "pending"
    )

    {
      bill: bill,
      breakdown: {
        days: days,
        bed_total: bed_charges,
        doctor_fee: doctor_fee,
        total: total
      }
    }
  end
end