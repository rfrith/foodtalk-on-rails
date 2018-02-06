class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  before_action :check_consent

  def check_consent
    if user_signed_in? && current_user.survey_histories.completed_consent_form.empty?
      redirect_to show_survey_path("consent-form")
    end
  end

end
