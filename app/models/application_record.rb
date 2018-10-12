class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  scope :created_in_range, ->(date_range = nil)  { where(created_at: date_range.first.to_time.beginning_of_day..date_range.last.to_time.end_of_day) }
  scope :updated_in_range, ->(date_range = nil)  { where(updated_at: date_range.first.to_time.beginning_of_day..date_range.last.to_time.end_of_day) }
end
