module Notifications
  extend ActiveSupport::Concern

  VALID_NOTIFICATION_TYPES = [:info, :success, :warning, :error, :popup]

  class Notification
    attr_reader :type
    attr_reader :title
    attr_reader :message
    attr_reader :url
    attr_reader :timeout
    attr_reader :locale

    def initialize(type, title, message, timeout, url, locale = I18n.default_locale)
      raise "Invalid notification." unless title && VALID_NOTIFICATION_TYPES.include?(type)
      @type = type
      @title = title
      @message = message
      @url = url
      @timeout = timeout
      @locale = locale
    end
  end
end