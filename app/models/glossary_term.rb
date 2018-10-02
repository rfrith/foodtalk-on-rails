class GlossaryTerm < ApplicationRecord
  mount_uploader :image, GlossaryImageUploader
  validates_presence_of :name, :description, :source, :remote_image_url
end
