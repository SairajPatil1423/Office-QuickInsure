class Bed < ApplicationRecord
  belongs_to :ward
  has_many :admissions

  validates :bed_number, presence: true
  validates :status, inclusion: { in: %w[available occupied] }

  validate :ward_capacity_not_exceeded, on: :create

  after_initialize do
    self.status ||= "available"
  end

  private

  def ward_capacity_not_exceeded
    if ward && ward.full?
      errors.add(:base, "Ward is full")
    end
  end
end