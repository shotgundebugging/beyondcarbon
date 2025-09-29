class Region < ApplicationRecord
  has_many :employment_data, class_name: "EmploymentData", dependent: :delete_all

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end

