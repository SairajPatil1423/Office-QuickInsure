class Medicine < ApplicationRecord
  has_many :prescription_medicines
  has_many :prescriptions, through: :prescription_medicines

  validates :name, presence: true
  validates :price, presence: true
end