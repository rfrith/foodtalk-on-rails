class SurveysController < ApplicationController
  include Secured
  def show
    case params[:id]

      #NOTE: surveys for learning modules are hard-coded from ArticulateStoryline as window.top.location.href = "/surveys/keeping-track"

      when "consent-form"
        @survey_url = get_survey_url"SV_9LTxafpuOXzgpTf", process_consent_form_path(current_user.uid)

      #TODO: move survey_id to learning_modules.rb???

      #Better U
      when "keeping-track"
        survey_id = LearningModules::find_survey_id('BETTER_U[:keeping_track]')
        @survey_url = get_survey_url survey_id, process_survey_path(LearningModules::find_lesson_id_by_survey_id(survey_id), current_user.uid)
      when "no-thanks-im-sweet-enough"
        survey_id = LearningModules::find_survey_id('BETTER_U[:no_thanks_im_sweet_enough]')
        @survey_url = get_survey_url survey_id, process_survey_path(LearningModules::find_lesson_id_by_survey_id(survey_id), current_user.uid)
      when "small-changes-equals-big-results"
        survey_id = LearningModules::find_survey_id('BETTER_U[:small_changes_equal_big_results]')
        @survey_url = get_survey_url survey_id, process_survey_path(LearningModules::find_lesson_id_by_survey_id(survey_id), current_user.uid)
      when "what-gets-in-the-weigh"
        survey_id = LearningModules::find_survey_id('BETTER_U[:what_gets_in_the_weigh]')
        @survey_url = get_survey_url survey_id, process_survey_path(LearningModules::find_lesson_id_by_survey_id(survey_id), current_user.uid)

      #Food eTalk
      # TODO: IMPLEMENT ME!!!!!!  Need Yukon to enable the .js redirects in the modules first


      #TODO: COMPLETE/FIX ME!!!!!!
      when "youtube-test"
        @survey_url = get_survey_url"SV_2shasM4V0EexFQ1", dashboard_show_path
      else
        raise "Invalid Survey URL provided."
    end

    current_user.survey_histories << SurveyHistory.new(name: LearningModules::find_lesson_id_by_survey_id(survey_id)+"#started")

  end

  def process_consent_form
    if(current_user.uid == params[:uid] && current_user.activity_histories.completed_consent_form.empty?)
      current_user.activity_histories << SurveyHistory.new(name: ActivityHistory::COMPLETED_CONSENT_FORM)
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

  def get_survey_url(survey_id, redirect)

    #TODO: REMOVE ME!!!!!!!!!
    if(!Rails.env.production?)
      survey_id = "SV_2shasM4V0EexFQ1" #this is our test web survey
    end

    return "https://ugeorgia.qualtrics.com/jfe/form/#{survey_id}?email=#{current_user.email}&uid=#{current_user.uid}&redirect=#{redirect}"
  end

end