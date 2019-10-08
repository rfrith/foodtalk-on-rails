class NotificationsController < ApplicationController

  def create
    authorize :notification, :create?
    type = params[:type].to_sym
    title = params[:title]
    message = params[:message]
    url = params[:url]
    timeout = params[:timeout]
    locale = params[:selected_locale]

    notification = Notification.new(type, title, message, timeout, url, locale)

    #TODO: move to offline job - NotificationBroadcastJob.perform_later notification.to_json
    NotificationBroadcastJob.perform_now notification.to_json

  end

end