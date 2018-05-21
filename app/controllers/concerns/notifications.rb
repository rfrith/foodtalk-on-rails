module Notifications

  #extend ActiveSupport::Concern

  VALID_NOTIFICATION_TYPES = [:info, :success, :warning, :error]

  @@notifications = []

  class Notification
    attr_reader :type
    attr_reader :title
    attr_reader :message
    attr_reader :timeout
    def initialize(type, title, message, timeout)
      raise "Invalid notification." unless title && VALID_NOTIFICATION_TYPES.include?(type)
      @type = type
      @title = title
      @message = message
      @timeout = timeout
    end
  end

  def add_notification(type, title, message, timeout)
    notification = Notification.new(type, title, message, timeout)
    @@notifications << notification unless @@notifications.include?(notification)
    #flash[:notifications] << Notification.new(type, title, message, timeout)
  end
  module_function :add_notification

  def get_notifications
    notifications = @@notifications
    return notifications
    #return flash[:notifications]
  end
  module_function :get_notifications

  def remove_notification(notification)
    @@notifications.delete(notification)
    #flash[:notifications].delete(notification)
  end
  module_function :remove_notification

  def destroy_all_notifications
    @@notifications = []
    #flash[:notifications] = []
  end
  module_function :destroy_all_notifications

end