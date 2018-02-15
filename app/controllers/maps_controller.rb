class MapsController < ApplicationController

  skip_before_action :check_consent
  skip_before_action :check_personal_info

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