class ZipCode < ApplicationRecord
  has_and_belongs_to_many :counties
  has_and_belongs_to_many :county_extension_offices
end