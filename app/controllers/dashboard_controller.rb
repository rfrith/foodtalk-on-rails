class DashboardController < ApplicationController
  include Secured, MailchimpHelper, DashboardHelper

  before_action :check_consent, only: [:show]

  def show
    @user = current_user
    @subscriptions = all_enabled_lists
  end

  private

  def check_consent
    if current_user.survey_histories.completed_consent_form.empty?
      redirect_to show_survey_path("consent-form")
    end
  end

end