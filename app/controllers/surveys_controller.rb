class SurveysController < ApplicationController
  def show
    @survey_url = "https://ugeorgia.qualtrics.com/jfe/form/"
    case params[:id]
      when "keeping-track"
        @survey_url += "SV_2m192rZTqtLT63H"
      when "no-thanks-im-sweet-enough"
        @survey_url += "SV_0CIDt2IgyAkApxj"
      when "small-changes-equals-big-results"
        @survey_url += "SV_5BAEJFx3222PkVL"
      when "youtube-test"
        @survey_url += "https://ugeorgia.qualtrics.com/jfe/form/SV_2shasM4V0EexFQ1"
      else
        raise "Invalid Survey URL provided."
    end
  end
end