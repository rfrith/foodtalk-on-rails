require 'rails_helper'

RSpec.describe  SurveyHistory,  type:  :model  do
  it "has a valid factory" do
    user = FactoryBot.create(:user)
    sh = FactoryBot.build(:survey_history)
    user.survey_histories << sh
    expect(sh).to be_valid
  end
end
