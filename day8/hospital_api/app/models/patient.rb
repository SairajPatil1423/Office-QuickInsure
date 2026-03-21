class Patient < ApplicationRecord
  has_many :appointments
  has_many :admissions
  has_many :bills

  validates :first_name, presence: true
  validates :phone, presence: true, uniqueness: true
  validates :email, uniqueness: true, allow_blank: true
end