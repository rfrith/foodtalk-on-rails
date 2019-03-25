module SurveysHelper

  include SessionsHelper

  def should_serve_survey?(survey_name, user)
    should_serve = false
    if VideoSurveys::find_video_by_name(survey_name)
      #TODO: should we limit video survey to eligible users who have filled out consent form?
      if(user_signed_in?)
        should_serve = user.survey_histories.where(name: "#{survey_name}#completed").empty? && user.is_eligible?
      end
    end
    return should_serve
  end

end