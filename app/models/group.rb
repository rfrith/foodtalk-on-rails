class Group < ApplicationRecord
  has_and_belongs_to_many :users

  validates_presence_of :name, :title, :domain #, :logo, :icon

  mount_uploader :logo, GroupLogoUploader
  mount_uploader :icon, GroupIconUploader
  FOODTALK_USERS = "foodtalk-users"

  scope :administrators, -> { where("name = ?", ADMIN) }

  def has_user(user)
    users.include?(user)
  end

end