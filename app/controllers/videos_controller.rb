class VideosController < ApplicationController
  def show
    @video_id = params[:id]
    @survey_url = "/surveys/youtube-test";
  end
end