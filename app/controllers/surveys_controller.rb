class SurveysController < ApplicationController
  include Secured
  def show
    case params[:id]
      when "consent-form"
        @survey_url = get_survey_url"SV_9LTxafpuOXzgpTf"
      when "keeping-track"
        @survey_url = get_survey_url "SV_2m192rZTqtLT63H"
      when "no-thanks-im-sweet-enough"
        @survey_url = get_survey_url "SV_0CIDt2IgyAkApxj"
      when "small-changes-equals-big-results"
        @survey_url = get_survey_url"SV_5BAEJFx3222PkVL"
      when "youtube-test"
        @survey_url = get_survey_url"SV_2shasM4V0EexFQ1"
      else
        raise "Invalid Survey URL provided."
    end
  end

  def process_consent_form
    if(current_user.uid == params[:uid] && !current_user.activity_histories.where(name: ActivityHistory::COMPLETED_CONSENT_FORM).take)
      current_user.activity_histories << ActivityHistory.new(name: ActivityHistory::COMPLETED_CONSENT_FORM)
    end
    redirect_to dashboard_show_path
  end


  private

  def get_survey_url(survey_id)
    return "https://ugeorgia.qualtrics.com/jfe/form/#{survey_id}?email=#{current_user.email}&uid=#{current_user.uid}&redirect=#{process_consent_form_path(current_user.uid)}"
  end

end