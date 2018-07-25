module Notifications
  extend ActiveSupport::Concern

  VALID_NOTIFICATION_TYPES = [:info, :success, :warning, :error]

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
end