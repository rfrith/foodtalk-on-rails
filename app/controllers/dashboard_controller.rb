class DashboardController < ApplicationController
  include Secured, MailchimpHelper, DashboardHelper

  before_action :check_consent, only: [:show]

  def show
    @user = current_user
    @subscriptions = all_enabled_lists
    @open_food_etalk_enrollments = open_food_etalk_enrollments
    @open_better_u_enrollments = open_better_u_enrollments
    @closed_food_etalk_enrollments = closed_food_etalk_enrollments
    @closed_better_u_enrollments = closed_better_u_enrollments
  end

  private

  def check_consent
    if !current_user.activity_histories.where(name: ActivityHistory::COMPLETED_CONSENT_FORM).take
      redirect_to show_survey_path("consent-form")
    end
  end

end