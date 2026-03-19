class Department < ApplicationRecord
  has_many :doctors

  belongs_to :dept_head, class_name: "Doctor", optional: true

  validates :name, presence: true, uniqueness: true
end