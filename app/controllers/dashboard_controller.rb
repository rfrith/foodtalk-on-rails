class DashboardController < ApplicationController
  include Secured
  include MailchimpHelper
  def show
    @user = current_user
    @subscriptions = get_all_enabled_lists
  end
end