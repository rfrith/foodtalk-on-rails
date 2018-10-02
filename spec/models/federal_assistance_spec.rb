require 'rails_helper'

RSpec.describe  FederalAssistance,  type:  :model  do

  it "has a valid factory" do
    user = FactoryBot.build(:user)
    federal_assistance = FactoryBot.build(:federal_assistance)
    user.federal_assistances << federal_assistance
    expect(federal_assistance).to be_valid
  end

end