class ErrorsController < ApplicationController

  skip_before_action :current_user

  class ErrorPageMessage < Struct.new(:status, :title, :message)
  end

  def bad_request
    respond_to do |format|
      @error = Rails.cache.fetch("HTTP400", expires_in: 1.day) do
        ErrorPageMessage.new(400, t("error_pages.http400.label"), t("error_pages.http400.description"))
      end
      format.html { render :template => "errors/error" }
      format.json { render json: { title: @error.title }, status: @error.status }
    end
  end

  def not_found
    @error = Rails.cache.fetch("HTTP404", expires_in: 1.day) do
      ErrorPageMessage.new(404, t("error_pages.http404.label"), t("error_pages.http404.description"))
    end
    respond_to do |format|
      format.html { render :template => "errors/error" }
      format.json { render json: { title: @error.title }, status: @error.status }
    end
  end

  def unacceptable
    @error = Rails.cache.fetch("HTTP422", expires_in: 1.day) do
      ErrorPageMessage.new(422, t("error_pages.http422.label"), t("error_pages.http422.description"))
    end
    respond_to do |format|
      format.html { render :template => "errors/error" }
      format.json { render json: { title: @error.title }, status: @error.status }
    end
  end

  def internal_error
    @error = Rails.cache.fetch("HTTP500", expires_in: 1.day) do
      ErrorPageMessage.new(500, t("error_pages.http500.label"), t("error_pages.http500.description"))
    end
    respond_to do |format|
      format.html { render :template => "errors/error" }
      format.json { render json: { title: @error.title }, status: @error.status }
    end
  end

end