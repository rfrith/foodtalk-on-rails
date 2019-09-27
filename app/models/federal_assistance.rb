class FederalAssistance < ApplicationRecord
  extend Mobility
  translates :name

  has_and_belongs_to_many :users
  validates_presence_of :name
end
