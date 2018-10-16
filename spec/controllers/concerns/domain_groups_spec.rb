require 'rails_helper'

class FakeController < ApplicationController
  include DomainGroups
end

describe FakeController do

  include_context "project setup"

  it "adds a user to domain group" do
    subject.add_user_to_domain_group(user, mhc.name)

    result = false
    DomainGroups::DOMAIN_GROUPS.each do |dg|
      if (dg[:group_name] == mhc.name)
        result = true
      end
    end

    expect(result).to eq true
    expect(DomainGroups.find_domain_group(:hhip)[:id]).to eq :hhip
    expect(DomainGroups.user_belongs_to_domain_group(user, mhc.name)).to eq true
    expect(user.groups.exists?(name: mhc.name)).to eq true
  end

end