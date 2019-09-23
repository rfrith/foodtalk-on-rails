class ApplicationController < ActionController::Base

  include Pundit, SessionsHelper, Notifications

  protect_from_forgery with: :exception
  before_action :current_user
  around_action :switch_locale

  helper_method :get_notifications


  def default_url_options
    if(policy(:site_access).view_spanish_content?)
      { locale: (params[:locale] || I18n.locale) }
    else
      { locale: I18n.default_locale }
    end
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  #TODO: add to DB and implement lifespan etc.
  def add_notification(type, title, message, timeout=false, url=nil)
    session[:notifications] ||= []
    notification = Notification.new(type, title, message, timeout, url)
    session[:notifications] << notification.instance_values
    logger.debug "Added notification to session."
  end

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    logger.info "User not authorized for: #{controller_name} #{policy_name}.#{exception.query}"
    redirect_to("/422")
  end

  def switch_locale(&action)
    locale = session[:locale] ||= I18n.default_locale
    if(policy(:site_access).view_spanish_content?)
      if params[:locale]
        #compare to what's in session
        if(session[:locale] != params[:locale])
          locale = params[:locale]
          #update session if different
          session[:locale] = locale
        end
      end
    end
    I18n.with_locale(locale, &action)
  end

  def get_notifications
    notifications = session[:notifications]
    session[:notifications] = nil
    return notifications
  end

  def initialize_date_range
    begin
      start_date = Time.zone.parse params[:start_date] unless params[:start_date].nil?
      end_date = Time.zone.parse params[:end_date] unless params[:end_date].nil?
    rescue ArgumentError => e
      #do nothing
    end
    range = initialize_date_range_for_reports(start_date...end_date)
    @start_date = range.first.to_date
    @end_date = range.last.to_date
  end

end