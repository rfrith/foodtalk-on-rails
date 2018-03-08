class DashboardController < ApplicationController
  include Secured, MailchimpHelper, DashboardHelper

  #TODO: FIX OR REMOVE ME!
  #skip_before_action :check_personal_info
  before_action :check_consent

  def show
    @subscriptions = all_enabled_lists
  end
end