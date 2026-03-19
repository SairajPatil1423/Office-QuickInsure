class Ward < ApplicationRecord
  has_many :rooms

  validates :ward_name, presence: true
end