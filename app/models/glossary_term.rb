class GlossaryTerm < ApplicationRecord
  mount_uploader :image, GlossaryImageUploader
  has_and_belongs_to_many :recipes, optional: true
end
