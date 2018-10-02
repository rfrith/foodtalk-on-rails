require 'rails_helper'

describe SurveysHelper, type: :helper do

  include_context "project setup"

  describe "#should_serve_survey?" do

    it "should serve survey to eligible, logged-in user for a survey with an existing id" do
      session[:auth_hash] = {test: "test"}
      user = FactoryBot.create(:user, :is_eligible)
      survey_name = VideoSurveys.find_video_by_id("nx5L4Tulv7Q")[:survey_args][:origin]
      expect(should_serve_survey?(survey_name, user)).to be true
    end

    it "should not serve survey to eligible, logged-in user for a survey with a non-existing id" do
      session[:auth_hash] = {test: "test"}
      user = FactoryBot.create(:user, :is_eligible)
      survey_name = "ABCDEFG"
      expect(should_serve_survey?(survey_name, user)).to be false
    end

    it "should not serve survey to ineligible, logged-in user for a survey with an existing id" do
      session[:auth_hash] = {test: "test"}
      user = FactoryBot.create(:user)
      survey_name = VideoSurveys.find_video_by_id("nx5L4Tulv7Q")[:survey_args][:origin]
      expect(should_serve_survey?(survey_name, user)).to be false
    end

    it "should not serve survey to non-logged-in user for a survey with an existing id" do
      user = FactoryBot.create(:user)
      survey_name = VideoSurveys.find_video_by_id("nx5L4Tulv7Q")[:survey_args][:origin]
      expect(should_serve_survey?(survey_name, user)).to be false
    end

  end

end
