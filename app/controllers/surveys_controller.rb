class SurveysController < ApplicationController
  include Secured

  skip_before_action :check_consent

  def show
    case params[:id]

      when "consent-form"
        @survey_url = get_survey_url"SV_9LTxafpuOXzgpTf", process_consent_form_path(current_user.uid)

      #NOTE: surveys for learning modules are hard-coded from ArticulateStoryline as window.top.location.href = "/surveys/keeping-track"

      #Better U
      when "keeping-track"
        @survey_url = prep_module_survey 'BETTER_U[:keeping_track]'
      when "no-thanks-im-sweet-enough"
        @survey_url = prep_module_survey 'BETTER_U[:no_thanks_im_sweet_enough]'
      when "small-changes-equals-big-results"
        @survey_url = prep_module_survey 'BETTER_U[:small_changes_equal_big_results]'
      when "what-gets-in-the-weigh"
        @survey_url = prep_module_survey 'BETTER_U[:what_gets_in_the_weigh]'

      #Food eTalk
      when "your-food-your-choice"
        @survey_url = prep_module_survey 'FOOD_ETALK[:your_food_your_choice]'
      when "keep-your-pressure-in-check"
        @survey_url = prep_module_survey 'FOOD_ETALK[:keep_your_pressure_in_check]'
      when "color-me-healthy"
        @survey_url = prep_module_survey 'FOOD_ETALK[:color_me_healthy]'
      when "eat-well-on-the-go"
        @survey_url = prep_module_survey 'FOOD_ETALK[:eat_well_on_the_go]'
      when "keep-yourself-well"
        @survey_url = prep_module_survey 'FOOD_ETALK[:keep_yourself_well]'
      when "play-food-etalk"
        @survey_url = prep_module_survey 'FOOD_ETALK[:play_food_etalk]'
      
      #TODO: COMPLETE/FIX ME!!!!!!
      when "youtube-test"
        @survey_url = get_survey_url"SV_2shasM4V0EexFQ1", dashboard_show_path
      else
        raise "Invalid Survey URL provided."
    end

  end

  def process_consent_form
    if(current_user.uid == params[:uid] && current_user.survey_histories.completed_consent_form.empty?)
      current_user.activity_histories << SurveyHistory.new(name: SurveyHistory::COMPLETED_CONSENT_FORM)
    end
    redirect_to dashboard_show_path
  end

  def process_survey
    #TODO: optimize me--make function to return lesson.id based on supplied name (e.g, LearningModules::find_module_id_by_name(params[:id])
    #find Lesson.id
    lesson_id = params[:id]
    if((current_user.uid == params[:uid]) && LearningModules::valid_module_id?(lesson_id))
      current_user.survey_histories << SurveyHistory.new(name: lesson_id+"#completed")
    end
    redirect_to complete_module_path(lesson_id, current_user.uid)
  end


  private

  def prep_module_survey(module_id)
    survey_id = LearningModules::find_survey_id(module_id)
    lesson_id = LearningModules::find_lesson_id_by_survey_id(survey_id)
    survey_url = get_survey_url survey_id, process_survey_path(lesson_id, current_user.uid)
    current_user.survey_histories << SurveyHistory.new(name: lesson_id+"#started")
    return survey_url
  end


  def get_survey_url(survey_id, redirect)

    #TODO: REMOVE ME!!!!!!!!!
    if(!Rails.env.production?)
      survey_id = "SV_2shasM4V0EexFQ1" #this is our test web survey
    end

    return "https://ugeorgia.qualtrics.com/jfe/form/#{survey_id}?email=#{current_user.email}&uid=#{current_user.uid}&redirect=#{redirect}"
  end

end