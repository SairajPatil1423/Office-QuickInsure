class Admission < ApplicationRecord
  belongs_to :patient
  belongs_to :bed

  def self.admit_patient(patient_id, bed_id)
    patient = Patient.find_by(id: patient_id)
    bed = Bed.find_by(id: bed_id)

    return { error: "Patient not found" } unless patient
    return { error: "Bed not found" } unless bed

    if exists?(patient_id: patient.id, discharge_date: nil)
      return { error: "Already admitted" }
    end

    if bed.status == "occupied"
      return { error: "Bed occupied" }
    end

    admission = create(
      patient_id: patient.id,
      bed_id: bed.id,
      admission_date: Date.today
    )

    if admission.persisted?
      bed.update(status: "occupied")
      { admission: admission }
    else
      { error: admission.errors.full_messages }
    end
  end

  def discharge!
    return { error: "Already discharged" } if discharge_date.present?

    update(discharge_date: Date.today)
    bed.update(status: "available")

    { success: "Discharged" }
  end
end