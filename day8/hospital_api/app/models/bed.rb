class Bed < ApplicationRecord
  belongs_to :room
  has_many :admissions

  validates :bed_number, presence: true
end