class DashboardController < ApplicationController
  include Secured, MailchimpHelper, DashboardHelper

  skip_before_action :check_personal_info

  def show
    @subscriptions = all_enabled_lists
  end
end