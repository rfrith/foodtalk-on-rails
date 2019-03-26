class MapsController < ApplicationController

  caches_page :index, :show, :expires_in => 1.week

  def index
  end

  def show
    map = Maps::find_map(params[:id])
    if(map)
      @map_name = map[:title]
      @map_url = map[:target_url]
    else
      raise ActionController::RoutingError.new('Map Not Found')
    end
  end
end