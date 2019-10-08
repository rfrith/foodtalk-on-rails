module NotificationHelper
  def get_notification_class(notification)
    case notification['type'].to_sym
    when :info
      "alert-info"
    when :success
      "alert-success"
    when :warning
      "alert-warning"
    when :error
      "alert-danger"
    when :popup
      "alert-secondary"
    end
  end
end