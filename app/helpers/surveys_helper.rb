module SurveysHelper
  include SessionsHelper

  def should_serve_survey?(survey_name, current_user)
    serve = false
    if VideoSurveys::find_video_by_name(survey_name) && current_user.survey_histories.where(name: "#{survey_name}#completed").empty?
      serve = (user_signed_in? && current_user.is_eligible?)
    end
    return serve
  end

end