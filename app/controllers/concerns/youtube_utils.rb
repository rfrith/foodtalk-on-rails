module YoutubeUtils
  extend ActiveSupport::Concern

  BASE_API_URL = "https://www.googleapis.com/youtube/v3/"
  PLAYLISTS = "playlists"
  PLAYLIST_ITEMS = "playlistItems"
  BASE_QUERYSTRING = "?part=snippet%2CcontentDetails&type=video&key=#{Rails.application.secrets.youtube_api_key}&channelId=#{Rails.application.secrets.youtube_channel_id}"

  def get_playlist_items(cache_key, playlist_id, max_results, order="date", page_token=nil)
    playlist_items_url = BASE_API_URL + PLAYLIST_ITEMS + BASE_QUERYSTRING + "&playlistId=#{playlist_id}&maxResults=#{max_results}&order=#{order}&pageToken=#{page_token}"
    JSON.parse get_cached_api_response(cache_key, URI(playlist_items_url)).body
  end

  def get_playlists(cache_key, max_results)
    playlists_url = BASE_API_URL + PLAYLISTS + BASE_QUERYSTRING + "&maxResults=#{max_results}"
    JSON.parse get_cached_api_response(cache_key, URI(playlists_url)).body
  end

  def get_playlist_id(params)
    playlist_id = params[:playlist_id]
    playlist_id ? playlist_id : Rails.application.secrets.youtube_default_channel
  end

end