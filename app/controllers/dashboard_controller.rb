class DashboardController < ApplicationController
  include Secured, MailchimpHelper, DashboardHelper

  before_action :check_consent, only: [:show]
  skip_before_action :check_personal_info

  def show
    @user = current_user
    @subscriptions = all_enabled_lists
  end
end