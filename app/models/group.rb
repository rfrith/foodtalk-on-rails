class Group < ApplicationRecord
  has_and_belongs_to_many :users
  mount_uploader :logo, GroupLogoUploader
  mount_uploader :icon, GroupIconUploader

  ADMIN = "admin"

end