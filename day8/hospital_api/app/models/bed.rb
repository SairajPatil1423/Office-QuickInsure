class Bed < ApplicationRecord
  belongs_to :ward
  has_many :admissions

  after_initialize do
    self.status ||= "available"
  end

  def price_per_day
    case ward.ward_type
    when "general"
      2000
    when "icu"
      5000
    when "emergency"
      3000
    else
      2000
    end
  end
end