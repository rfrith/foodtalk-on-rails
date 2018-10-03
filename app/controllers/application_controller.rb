class ApplicationController < ActionController::Base

  include Pundit, SessionsHelper, Notifications

  protect_from_forgery with: :exception
  before_action :current_user, :set_locale

  helper_method :get_notifications

  def default_url_options
    if(Rails.application.secrets.i18n_enabled || params[:locale])
      { locale: I18n.locale }
    else
      { locale: nil }
    end
  end

  def add_notification(type, title, message, timeout)
    session[:notifications] ||= []
    notification = Notification.new(type, title, message, timeout)
    session[:notifications] << notification.instance_values
    logger.debug "Added notification to session"
  end

  private

  def set_locale
    I18n.locale = !params[:locale].blank? ? params[:locale] : I18n.default_locale
  end

  def get_notifications
    notifications = session[:notifications]
    session[:notifications] = []
    return notifications
  end

  def initialize_date_range
    begin
      start_date = DateTime.parse params[:start_date] unless params[:start_date].nil?
      end_date = DateTime.parse params[:end_date] unless params[:end_date].nil?
    rescue ArgumentError => e
      #do nothing
    end
    range = initialize_date_range_for_reports(start_date...end_date)
    @start_date = range.first.to_date
    @end_date = range.last.to_date
  end

end