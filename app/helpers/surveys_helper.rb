module SurveysHelper
  include SessionsHelper

  def should_serve_survey(survey_name, current_user)
    return (survey_name && user_signed_in? && current_user.is_eligible? && current_user.survey_histories.where(name: "#{survey_name}#completed").empty?)
  end

end