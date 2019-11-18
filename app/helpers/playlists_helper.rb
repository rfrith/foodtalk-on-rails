module PlaylistsHelper
  def added_to_playlist(url)
    @current_user.playlist_items.exists?(url: url)
  end
end