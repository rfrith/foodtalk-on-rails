require 'rails_helper'

RSpec.describe  RacialIdentity,  type:  :model  do
  it "has a valid factory" do
    racial_identity = FactoryBot.create(:racial_identity)
    expect(racial_identity).to be_valid
  end
end