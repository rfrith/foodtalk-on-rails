require 'rails_helper'

RSpec.describe  Group,  type:  :model  do
  it "has a valid factory" do
    group = FactoryBot.build(:group)
    expect(group).to be_valid
  end
end
