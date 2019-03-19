class ActivityHistory < ApplicationRecord
  belongs_to :user
  has_many :groups, through: :user

  scope :started, -> { where("name like '%#started'") }
  scope :completed, -> { where("name like '%#completed'") }

  validates_presence_of :name, :user
end
