class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  before_action :check_consent
  before_action :check_personal_info


  def check_consent
    if user_signed_in? && current_user.survey_histories.completed_consent_form.empty?
      redirect_to show_survey_path('consent-form')
    end
  end

  def check_personal_info
    if user_signed_in? && !current_user.valid?
      redirect_to dashboard_show_path
    end
  end

end