class Playlist < ApplicationRecord
  belongs_to :user
  has_many :playlist_items

  include RankedModel
  ranks :position

  enum category: {recipe: 0, blog: 1, video: 2}
end
