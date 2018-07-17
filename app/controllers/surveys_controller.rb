class SurveysController < ApplicationController
  include Secured

  def show
    #set to false for any surveys that should NOT have header & footer elements
    @full_screen = false

    if(params[:id] == 'consent-form')
      add_notification :info, t(:info), t(:thank_you) + " "+ t(:ask_for_feedback), 20000
    else
      add_notification :info, t(:info), t(:ask_for_feedback), 20000
    end

    case params[:id]

    when "consent-form"
      @current_user.survey_histories << SurveyHistory.new(name: SurveyHistory::STARTED_CONSENT_FORM)
      @survey_url = get_survey_url"SV_9LTxafpuOXzgpTf", process_consent_form_url(@current_user.uid)

    #NOTE: surveys for learning modules are hard-coded from ArticulateStoryline as window.top.location.href = "/surveys/keeping-track"
    #Better U
    when "keeping-track"
      @survey_url = prep_module_survey 'better_u/keeping_track'
    when "no-thanks-im-sweet-enough"
      @survey_url = prep_module_survey 'better_u/no_thanks_im_sweet_enough'
    when "small-changes-equals-big-results"
      @survey_url = prep_module_survey 'better_u/small_changes_equal_big_results'
    when "what-gets-in-the-weigh"
      @survey_url = prep_module_survey 'better_u/what_gets_in_the_weigh'

    #Food eTalk
    when "your-food-your-choice"
      @survey_url = prep_module_survey 'food_etalk/your_food_your_choice'
    when "keep-your-pressure-in-check"
      @survey_url = prep_module_survey 'food_etalk/keep_your_pressure_in_check'
    when "color-me-healthy"
      @survey_url = prep_module_survey 'food_etalk/color_me_healthy'
    when "eat-well-on-the-go"
      @survey_url = prep_module_survey 'food_etalk/eat_well_on_the_go'
    when "keep-yourself-well"
      @survey_url = prep_module_survey 'food_etalk/keep_yourself_well'
    when "play-food-etalk"
      @survey_url = prep_module_survey 'food_etalk/play_food_etalk'

    #video surveys
    when *VideoSurveys::get_survey_names
      @survey_url = prep_video_survey params[:id]

    else
      raise "Invalid Survey URL provided."
    end

    redirect_to @survey_url

  end

  def process_consent_form
    if(@current_user.uid == params[:uid] && @current_user.survey_histories.completed_consent_form.empty?)
      @current_user.activity_histories << SurveyHistory.new(name: SurveyHistory::COMPLETED_CONSENT_FORM)
    end

    if(@current_user.is_eligible?)
      redirect_to show_dashboard_path
    else
      redirect_to root_path
    end

  end

  def process_survey
    #TODO: optimize me--make function to return .id based on supplied name (e.g, LearningModules::find_module_id_by_name(params[:id])
    survey_name = "#{params[:type]}/#{params[:name]}"
    if @current_user.uid == params[:uid]
      if(LearningModules::valid_module_id?(survey_name) || (VideoSurveys::valid_video_survey?(survey_name)))
        @current_user.survey_histories << SurveyHistory.new(name: survey_name+"#completed")
      end
      if LearningModules::valid_module_id? survey_name
        redirect_to complete_module_path(survey_name, @current_user.uid)
      elsif VideoSurveys::valid_video_survey? survey_name
        redirect_to videos_path
      else
        raise "Invalid Survey name provided."
      end
    end
  end


  private

  def prep_module_survey(module_id)
    survey_id = LearningModules::find_survey_id(module_id)
    lesson_id = LearningModules::find_lesson_id_by_survey_id(survey_id)

    id_split = lesson_id.split('/')
    type = id_split[0]
    name = id_split[1]

    survey_url = get_survey_url survey_id, process_survey_url(type: type, name: name, uid: @current_user.uid), lesson_id
    @current_user.survey_histories << SurveyHistory.new(name: lesson_id+"#started")
    return survey_url
  end

  def prep_video_survey(survey_name)
    video = VideoSurveys.find_video_by_name(survey_name)
    survey_id = video[:survey_id]
    video_name = video[:survey_args][:origin]
    survey_url = get_survey_url survey_id, process_survey_url(type: "video", name: video_name, uid: @current_user.uid), video[:survey_args][:origin]
    @current_user.survey_histories << SurveyHistory.new(name: "#{video_name}#started")
    return survey_url
  end

  def get_survey_url(survey_id, redirect, origin = nil)


    if(Rails.application.secrets.use_test_survey)
      survey_id = "SV_2shasM4V0EexFQ1" #this is our test web survey
    end

    url = "#{Rails.application.secrets.qualtrics_survey_base_url}#{survey_id}?origin=#{origin}&email=#{@current_user.email}&uid=#{@current_user.uid}&redirect=#{redirect}&Q_Language=#{I18n.locale.upcase}"

    return url

  end

end