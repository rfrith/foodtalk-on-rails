class PlaylistItem < ApplicationRecord
  belongs_to :playlist
  has_one :user, through: :playlist

  include RankedModel
  ranks :position

  enum category: {recipe: 0, blog: 1, video: 2}
end
