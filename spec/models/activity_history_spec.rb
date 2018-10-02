require 'rails_helper'

RSpec.describe  ActivityHistory,  type:  :model  do

  it "has a valid factory" do
    user = FactoryBot.build(:user)
    ah = FactoryBot.build(:activity_history)
    user.activity_histories << ah
    expect(ah).to be_valid
  end

  it "is valid w/ :name" do
    user = FactoryBot.build(:user)
    ah = FactoryBot.build(:activity_history)
    user.activity_histories << ah
    expect(user.activity_histories.size).to eq 1
    expect(user.activity_histories.first.name).to eq "Test History"
  end

  it "is invalid w/out :name, :user" do
    ah = ActivityHistory.new
    expect(ah.valid?).to eq false

    ah.name = "Test Activity2"
    expect(ah.valid?).to eq false

    user = FactoryBot.build(:user)
    ah = FactoryBot.build(:activity_history)
    user.activity_histories << ah

    ah.user_id = user.id
    expect(ah.valid?).to eq true
  end

end
