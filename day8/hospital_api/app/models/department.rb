class Department < ApplicationRecord
  has_many :doctors

  validates :name, presence: true, uniqueness: true

  def self.revenue_report
    joins(doctors: :appointments)
      .group("departments.id")
      .select(
        "departments.id, departments.name,
        SUM(doctors.consultation_fee) AS revenue"
      )
  end
  
end