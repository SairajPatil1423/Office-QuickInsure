class Medicine < ApplicationRecord
  has_many :prescription_medicines
  has_many :prescriptions, through: :prescription_medicines
end