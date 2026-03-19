class Room < ApplicationRecord
  belongs_to :ward
  has_many :beds

  validates :room_number, presence: true
end