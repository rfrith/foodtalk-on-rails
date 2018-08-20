class ActivityHistory < ApplicationRecord
  belongs_to :user

  scope :started, -> { where("name like '%#started'") }
  scope :completed, -> { where("name like '%#completed'") }

end
