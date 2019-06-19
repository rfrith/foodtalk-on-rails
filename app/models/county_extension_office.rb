class CountyExtensionOffice < ApplicationRecord
  has_and_belongs_to_many :counties
  has_and_belongs_to_many :zip_codes
end
