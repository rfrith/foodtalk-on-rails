class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper, Notifications

  before_action :set_current_user, :clear_notifications, :set_notifications, :set_locale

  def default_url_options
    { locale: I18n.locale }
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  #TODO: IMPLEMENT ME
  def clear_notifications
    Notifications.destroy_all_notifications
  end

  def set_notifications
    @notifications = Notifications.get_notifications
  end

end