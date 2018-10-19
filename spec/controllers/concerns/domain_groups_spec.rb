require 'rails_helper'

class DomainGroupsSpec < ApplicationController
  include DomainGroups
end

describe DomainGroupsSpec do

  include_context "project setup"

  it "has a valid factory" do
    expect(DomainGroups.find_domain_group(:mhc)[:id]).to eq :mhc
    expect(DomainGroups.find_domain_group(:hhip)[:id]).to eq :hhip

    result = false
    DomainGroups::DOMAIN_GROUPS.each do |dg|

      if (dg[:group_name] == mhc.name)
        result = true
      end
    end

    expect(result).to eq true



  end


  it "adds a user to domain group" do

    subject.add_user_to_domain_group(user, criteria: :domain, value: mhc.domain)

    expect(DomainGroups.user_belongs_to_domain_group(user, criteria: :name, value: mhc.name)).to eq true
    expect(DomainGroups.user_belongs_to_domain_group(user, criteria: :domain, value: mhc.domain)).to eq true
    expect(user.groups.exists?(name: mhc.name)).to eq true

    #subject.add_user_to_domain_group(eligible_user, criteria: :name, value: hhip.name)
    #expect(DomainGroups.user_belongs_to_domain_group(eligible_user, criteria: :name, value: hhip.name)).to eq true
    #expect(DomainGroups.user_belongs_to_domain_group(eligible_user, criteria: :domain, value: hhip.domain)).to eq true
    #expect(eligible_user.groups.exists?(name: hhip.name)).to eq true

  end

end