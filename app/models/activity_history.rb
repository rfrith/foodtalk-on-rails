class ActivityHistory < ApplicationRecord
  belongs_to :user

  scope :started, -> { where("name like '%#started'") }
  scope :completed, -> { where("name like '%#completed'") }

  scope :created_in_range, ->(date_range = nil)  { where(created_at: date_range.first.to_time.beginning_of_day..date_range.last.to_time.end_of_day) }
  scope :updated_in_range, ->(date_range = nil)  { where(updated_at: date_range.first.to_time.beginning_of_day..date_range.last.to_time.end_of_day) }

  validates_presence_of :name, :user
end
