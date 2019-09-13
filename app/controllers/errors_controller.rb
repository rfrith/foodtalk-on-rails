class ErrorsController < ApplicationController

  skip_before_action :current_user

  class ErrorPageMessage < Struct.new(:status, :title, :message)
  end

  def bad_request
    respond_to do |format|
      @error = Rails.cache.fetch("HTTP400", expires_in: 1.day) do
        #TODO: I18N ME!!!
        ErrorPageMessage.new(400, "Bad Request.", "We are sorry, something appears to be wrong with the request you made, please try again.")
      end
      format.html { render :template => "errors/error" }
      format.json { render json: { title: @error.title }, status: @error.status }
    end
  end

  def not_found
    @error = Rails.cache.fetch("HTTP404", expires_in: 1.day) do
      #TODO: I18N ME!!!
      ErrorPageMessage.new(404, "Page not found.", "We are sorry, the page you requested cannot be found. The URL may be misspelled or the page you're looking for is no longer available.")
    end
    respond_to do |format|
      format.html { render :template => "errors/error" }
      format.json { render json: { title: @error.title }, status: @error.status }
    end
  end

  def unacceptable
    @error = Rails.cache.fetch("HTTP422", expires_in: 1.day) do
      #TODO: I18N ME!!!
      ErrorPageMessage.new(422, "The action you requested was rejected.", "We are sorry, you requested something you didn't have access to.")
    end
    respond_to do |format|
      format.html { render :template => "errors/error" }
      format.json { render json: { title: @error.title }, status: @error.status }
    end
  end

  def internal_error
    @error = Rails.cache.fetch("HTTP500", expires_in: 1.day) do
      #TODO: I18N ME!!!
      ErrorPageMessage.new(500, "Internal Server Error.", "We are sorry, something went wrong. Our technical team will investigate the issue. Please try again shortly.")
    end
    respond_to do |format|
      format.html { render :template => "errors/error" }
      format.json { render json: { title: @error.title }, status: @error.status }
    end
  end

end