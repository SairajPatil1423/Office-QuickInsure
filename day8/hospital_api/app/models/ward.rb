class Ward < ApplicationRecord
  has_many :beds, dependent: :destroy

  validates :ward_name, presence: true
  validates :capacity, presence: true,
                       numericality: { greater_than: 0 }

  
  def full?
    beds.count >= capacity
  end
end