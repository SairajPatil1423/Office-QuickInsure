class Room < ApplicationRecord
  belongs_to :ward
  has_many :beds
end