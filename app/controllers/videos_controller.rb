class VideosController < ApplicationController
  def index
    @videos=Video.all
  end

  def show
    @video_id = params[:id]
    @survey_url = "/surveys/youtube-test";
  end
end