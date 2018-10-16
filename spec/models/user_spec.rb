require 'rails_helper'

RSpec.describe  User,  type:  :model  do

  include_context "project setup"

  #validation methods
  cant_be_blank = "can't be blank"
  has_already_been_taken = "has already been taken"
  is_invalid = "is invalid"
  is_not_a_number = "is not a number"

  it "has a valid factory" do
    expect(user).to be_valid
  end

  it "is invalid with a duplicate uid" do
    user2 = User.create(uid: static_user.uid)
    user2.valid?
    expect(user2.errors[:uid]).to include(has_already_been_taken)
  end

  it "is invalid without a uid" do
    user.uid = nil
    user.valid?
    expect(user.errors[:uid]).to include(cant_be_blank)
  end

  it "is invalid without a first name" do
    user.first_name = nil
    user.valid?
    expect(user.errors[:first_name]).to include(cant_be_blank)
  end

  it "is invalid without a last name" do
    user.last_name = nil
    user.valid?
    expect(user.errors[:last_name]).to include(cant_be_blank)
  end

  it "is invalid without age" do
    user.age = nil
    user.valid?
    expect(user.errors[:age]).to include(cant_be_blank)
  end

  it "validates_numericality_of :age" do
    user.age = "abc"
    user.valid?
    expect(user.errors[:age]).to include(is_not_a_number)
  end

  it "is invalid without gender" do
    user.gender = nil
    user.valid?
    expect(user.errors[:gender]).to include(cant_be_blank)
  end

  it "is invalid without zip_code" do
    user.zip_code = nil
    user.valid?
    expect(user.errors[:zip_code]).to include(cant_be_blank)
  end

  it "validates_length_of :zip_code, :is => 5" do
    user.zip_code = 1234
    user.valid?
    expect(user.errors[:zip_code]).to include("must be at least 5-digits.")
  end

  it "is invalid without an email address" do
    user.email = nil
    user.valid?
    expect(user.errors[:email]).to include(cant_be_blank)
  end

  it "is invalid with a duplicate email address" do
    user = User.new(email: static_user.email)
    user.valid?
    expect(user.errors[:email]).to include(has_already_been_taken)
  end

  it "is invalid with an incorrect email address format" do
    user.email = "tester-at-example.com"
    user.valid?
    expect(user.errors[:email]).to include(is_invalid)
  end

  it "is invalid without racial_identities" do
    user = FactoryBot.build(:user, :with_no_racial_identities)
    user.valid?
    expect(user.errors[:racial_identities]).to include(cant_be_blank)
  end

  it "validates_inclusion_of :is_hispanic_or_latino, :in => [true, false]" do
    user.is_hispanic_or_latino = nil
    user.valid?
    expect(user.errors[:is_hispanic_or_latino]).to include("Please answer the question 'Do you consider yourself Hispanic/Latino?'")
  end



  #instance methods

  it "find_or_initialize_from_auth_hash" do
    #find existing user
    auth_hash = {
        'uid' => static_user.uid,
        'first_name' => static_user.first_name,
        'last_name' => static_user.last_name,
        'email' => static_user.email,
    }
    user = User.find_or_initialize_from_auth_hash(auth_hash)
    expect(user.uid).to eq static_user.uid
    expect(user.first_name).to eq static_user.first_name
    expect(user.last_name).to eq static_user.last_name
    expect(user.email).to eq static_user.email
    expect(user.age).to eq static_user.age
    expect(user.gender).to eq static_user.gender
    expect(user.zip_code).to eq static_user.zip_code
    expect(user.is_hispanic_or_latino).to eq static_user.is_hispanic_or_latino
    expect(user.racial_identities_names).to eq static_user.racial_identities_names

    #create new user
    auth_hash = {
        'uid' => "testUid|123456789",
        'first_name' => "Testy",
        'last_name' => "Usery",
        'email' => "testy@email.com"
    }
  end

  it "returns a user's full name as a string" do
    expect(static_user.name).to eq "#{static_user.first_name} #{static_user.last_name}"
  end

  it "is_admin? = false" do
    user.groups = []
    expect(user.is_admin?).to eq false
  end

  it "is_admin? = true" do
    expect(admin_user.is_admin?).to eq true
  end

  it "is_eligible? = true" do
    expect(eligible_user.is_eligible?).to eq true
  end

  it "is_eligible? = false" do
    expect(ineligible_user.is_eligible?).to eq false
  end

  it "returns a list of eligible users" do
    eligible_user #lazy loaded
    expect(User.eligible).to include eligible_user
    ineligible_user #lazy loaded
    expect(User.eligible).not_to include ineligible_user
  end

  it "returns a list of ineligible users" do
    ineligible_user #lazy loaded
    expect(User.ineligible).to include ineligible_user
    eligible_user #lazy loaded
    expect(User.ineligible).not_to include eligible_user
  end

  it "group_names" do
    expect(user.group_names).to include "Foodtalk Users"
    expect(admin_user.group_names).to include "Foodtalk Admin Group"
  end

  it "racial_identities_names" do
    expect(user.racial_identities_names).to include white.name
    user.racial_identities = []
    expect(user.racial_identities_names).to eq ["None"]
  end

  it "federal_assistances_names" do
    #expect(user.federal_assistances_names).to eq ["None"]
    #user.federal_assistances << FederalAssistance.new(name: "Test Value")
    #expect(user.federal_assistances_names).to eq ["Test Value"]
  end

  it "email_as_md5_hash" do
    expect(user.email_as_md5_hash).to eq Digest::MD5.hexdigest(user.email)
  end

  it "search_by_full_name" do
    full_name = "#{user.first_name} #{user.last_name}"
    expect(User.search_by_full_name(full_name).size).to eq 1
    expect(User.search_by_full_name(full_name).first.name).to eq full_name
    expect(User.search_by_full_name(full_name).first.first_name).to eq user.first_name
    expect(User.search_by_full_name(full_name).first.last_name).to eq user.last_name
  end

  it "search_by_email" do
    expect(User.search_by_email(user.email).size).to eq 1
    expect(User.search_by_email(user.email).first.email).to eq user.email
  end

  it "not_in_group" do
    create_list(:user, 3)
    create_list(:user, 3, :admin)
    expect(User.not_in_group.size).to eq 3
  end

  it "in_group" do
    create_list(:user, 3, :admin)
    expect(User.in_group(Group::ADMIN).size).to eq 3
    expect(User.in_group(Group::ADMIN)).to include admin_user
    expect(User.in_group(Group::ADMIN)).to_not include user
    expect(User.all.size).to eq 5
  end

end
