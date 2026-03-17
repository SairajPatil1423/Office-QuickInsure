class Prescription < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor

  has_many :prescription_medicines
  has_many :medicines, through: :prescription_medicines
end