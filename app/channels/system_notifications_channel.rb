class SystemNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "system_notifications_channel_#{params[:locale]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
