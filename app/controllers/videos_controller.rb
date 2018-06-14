class VideosController < ApplicationController
  def index
    begin
      playlist = params[:playlist]

      if(playlist)
        @playlist_id = playlist
        playlist_items_url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&playlistId=#{playlist}&maxResults=25&key=#{Rails.application.secrets.youtube_api_key}"
      else
        @playlist_id = Rails.application.secrets.youtube_default_channel
        playlist_items_url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&playlistId=#{@playlist_id}&maxResults=25&key=#{Rails.application.secrets.youtube_api_key}"
      end

      playlists_url = "https://www.googleapis.com/youtube/v3/playlists?part=snippet%2CcontentDetails&channelId=#{Rails.application.secrets.youtube_channel_id}&maxResults=25&key=#{Rails.application.secrets.youtube_api_key}"
      playlists = Net::HTTP.get(URI(playlists_url))
      playlist_items = Net::HTTP.get(URI(playlist_items_url))

      @playlists = JSON.parse playlists
      @videos = JSON.parse playlist_items

    rescue
      #do nothing
    end

  end

  def show
    @video_id = params[:id]
    video = VideoSurveys.find_video_by_id(@video_id)
    if video && video[:survey_args]
      @survey_name = VideoSurveys.find_video_by_id(@video_id)[:survey_args][:origin]
    end
  end
end