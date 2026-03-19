class Patient < ApplicationRecord
  has_many :appointments
  has_many :prescriptions
  has_many :admissions
  has_many :bills

  validates :first_name, presence: true
  validates :phone, presence: true, uniqueness: true
  validates :email, uniqueness: true, allow_blank: true
  validates :gender, inclusion: { in: %w[male female] }, allow_blank: true
end