require 'rails_helper'

RSpec.describe  Group,  type:  :model  do

  include_context "project setup"

  it "has a valid factory" do
    expect(admin_group).to be_valid
    expect(mhc).to be_valid
  end

end
