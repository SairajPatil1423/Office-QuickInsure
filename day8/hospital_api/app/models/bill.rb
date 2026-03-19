class Bill < ApplicationRecord
  belongs_to :patient

  validates :total_amount, presence: true
end