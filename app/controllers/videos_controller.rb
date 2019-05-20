class VideosController < ApplicationController

  include ApiUtils
  PER_PAGE ||= 8

  def index
    begin
      playlist_id = params[:playlist_id]


      if(playlist_id)
        @playlist_id = playlist_id
      else
        @playlist_id = Rails.application.secrets.youtube_default_channel
      end

      playlist_items_url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&playlistId=#{@playlist_id}&maxResults=#{PER_PAGE}&order=date&type=video&key=#{Rails.application.secrets.youtube_api_key}"
      playlists_url = "https://www.googleapis.com/youtube/v3/playlists?part=snippet%2CcontentDetails&channelId=#{Rails.application.secrets.youtube_channel_id}&maxResults=50&key=#{Rails.application.secrets.youtube_api_key}"

      @playlists ||= JSON.parse get_cached_api_response('yt_playlists_index_replies', URI(playlists_url)).body
      @videos ||= JSON.parse get_cached_api_response('yt_videos_index_replies', URI(playlist_items_url)).body

      @nextPageToken = @videos["nextPageToken"]

    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end

  end

  def load_page
    begin
      get_videos
    rescue Exception => e
      logger.error "An error occurred: #{e.inspect}"
    end

    respond_to do |format|
      format.js
    end
  end

  def show
    @video_id = params[:id]
    video = VideoSurveys.find_video_by_id(@video_id)
    if video && video[:survey_args]
      @survey_name = VideoSurveys.find_video_by_id(@video_id)[:survey_args][:origin]
    end
  end

  private

  def get_videos
    @page_token = params[:page_token]

    if(@page_token)
      @posts_per_page = PER_PAGE
      @playlist_id = params[:playlist_id]

      playlist_items_url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&playlistId=#{@playlist_id}&maxResults=#{PER_PAGE}&order=date&type=video&pageToken=#{@page_token}&key=#{Rails.application.secrets.youtube_api_key}"

      @videos ||= JSON.parse get_cached_api_response("yt_videos_#{@page_token}_replies", URI(playlist_items_url)).body
      @nextPageToken = @videos["nextPageToken"]
    end

  end

end