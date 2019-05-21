class VideosController < ApplicationController

  include ApiUtils, YoutubeUtils
  PER_PAGE ||= 8

  def index
    begin
      @playlist_id = get_playlist_id(params)
      @videos = get_playlist_items("yt_videos_index_#{@playlist_id}_replies", @playlist_id, PER_PAGE)
      @playlists = get_playlists("yt_all_playlists_replies", 50)
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
    @playlist_id = get_playlist_id(params)
    page_token = params[:page_token]

    if page_token
      @videos = get_playlist_items("yt_videos_#{@playlist_id}_#{page_token}_replies", @playlist_id, PER_PAGE, "date", page_token)
      @nextPageToken = @videos["nextPageToken"]
    end

  end

end