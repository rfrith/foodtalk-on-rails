class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(notification)
    parsed_notification = JSON.parse notification
    #notification['message'], image: image_url("logo-sm.png", class: "img-fluid m-0 p-0")
    ActionCable.server.broadcast "system_notifications_channel_#{parsed_notification["locale"]}", message: render_message(parsed_notification)
  end
end


private

def render_message(parsed_notification)
  ApplicationController.renderer.render(partial: 'shared/notification', locals: { notification: parsed_notification })
end
