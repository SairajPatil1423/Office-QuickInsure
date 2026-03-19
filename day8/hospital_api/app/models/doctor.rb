class Doctor < ApplicationRecord
  belongs_to :department

  has_many :appointments
  has_many :prescriptions

  validates :name, presence: true
  validates :specialization, presence: true
  validates :phone, presence: true, uniqueness: true
end