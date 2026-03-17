class Admission < ApplicationRecord
  belongs_to :patient
  belongs_to :bed
end