class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper, Notifications

  before_action :set_current_user, :get_notifications, :set_locale
  after_action :clear_notifications

  def default_url_options
    if(Rails.application.secrets.i18n_enabled || params[:locale])
      { locale: I18n.locale }
    else
      { locale: nil }
    end
  end

  private

  def set_locale
    I18n.locale = !params[:locale].blank? ? params[:locale] : I18n.default_locale
  end

  #TODO: IMPLEMENT ME
  def clear_notifications
    Notifications.destroy_all_notifications
  end

  def get_notifications
    @notifications = Notifications.get_notifications
  end

end