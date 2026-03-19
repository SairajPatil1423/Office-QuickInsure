class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor

  validates :apt_date, presence: true
  validates :status, presence: true
end