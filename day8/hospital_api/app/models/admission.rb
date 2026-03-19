class Admission < ApplicationRecord
  belongs_to :patient
  belongs_to :bed

  validates :admission_date, presence: true
end