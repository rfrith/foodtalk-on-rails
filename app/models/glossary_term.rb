class GlossaryTerm < ApplicationRecord
  mount_uploader :image, GlossaryImageUploader
end
