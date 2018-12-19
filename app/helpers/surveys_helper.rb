module SurveysHelper

  def should_serve_survey?(survey_name, user)
    should_serve = false
    if VideoSurveys::find_video_by_name(survey_name)
      #TODO: should we limit video survey to eligible users who have filled out consent form?
      should_serve = user.survey_histories.where(name: "#{survey_name}#completed").empty? && user.is_eligible?
    end
    return should_serve
  end

end