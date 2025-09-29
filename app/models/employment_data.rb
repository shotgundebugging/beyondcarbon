class EmploymentData < ApplicationRecord
  self.table_name = "employment_data"

  belongs_to :region

  validates :sector, presence: true
  validates :stressor, presence: true
  validates :value, presence: true
end

