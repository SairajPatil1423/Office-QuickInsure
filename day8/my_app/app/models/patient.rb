class Patient < ApplicationRecord
  has_many :appointments
  has_many :prescriptions
  has_many :admissions
  has_many :bills

  has_one :patient_medical_history
  has_many :patient_vitals
  has_many :emergency_contacts
  has_one :insurance
end