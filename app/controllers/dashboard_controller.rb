class DashboardController < ApplicationController
  include Secured, MailchimpHelper, DashboardHelper

  before_action :check_consent, only: [:show]

  def show
    @user = current_user
    @subscriptions = all_enabled_lists
  end

  private



end