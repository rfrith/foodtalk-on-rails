require 'rails_helper'

class ReportsSpec < ApplicationController
  include Reports
end

describe ReportsSpec do

  include_context "project setup"

  it "creates header row properly" do

    users = [user_with_food_etalk_enrollment, user_with_better_u_enrollment, user_has_completed_food_etalk, user_has_completed_better_u]
    csv_string = subject.generate_report_as_csv(users)
    csv_contents = CSV.parse(csv_string)

    expect(csv_contents.size).to eq 5

    expect(csv_contents[0][0]).to eq "admin"
    expect(csv_contents[0][1]).to eq "group_admin"
    expect(csv_contents[0][2]).to eq "hancock-health-improvement-partnership"
    expect(csv_contents[0][3]).to eq "mercy-health-center"
    expect(csv_contents[0][4]).to eq "signup_date"
    expect(csv_contents[0][5]).to eq "uid"
    expect(csv_contents[0][6]).to eq "is_eligible"
    expect(csv_contents[0][7]).to eq "first_name"
    expect(csv_contents[0][8]).to eq "last_name"
    expect(csv_contents[0][9]).to eq "email"
    expect(csv_contents[0][10]).to eq "gender"
    expect(csv_contents[0][11]).to eq "age"
    expect(csv_contents[0][12]).to eq "zip_code"
    expect(csv_contents[0][13]).to eq "is_hispanic_or_latino"

    current_index = 14

    RacialIdentity.all.each_with_index do |ri, index|
      element = csv_contents[0][(current_index + index)]
      expect(element).to eq ri.name.parameterize.underscore
    end

    current_index += RacialIdentity.all.size

    FederalAssistance.all.each_with_index do |fa, index|
      element = csv_contents[0][(current_index + index)]
      expect(element).to eq fa.name.parameterize.underscore
    end

    current_index += FederalAssistance.all.size

    LearningModules::BETTER_U.each_with_index do |m, index|
      element = csv_contents[0][(current_index + index)]
      expect(element).to eq m[:id].gsub("/", "_").gsub("#", "_") + "_started"
      current_index += 1
      element2 = csv_contents[0][(current_index + index)]
      expect(element2).to eq m[:id].gsub("/", "_").gsub("#", "_") + "_completed"
    end

    current_index += LearningModules::BETTER_U.size

    LearningModules::FOOD_ETALK.each_with_index do |m, index|
      element = csv_contents[0][(current_index + index)]
      expect(element).to eq m[:id].gsub("/", "_").gsub("#", "_") + "_started"
      current_index += 1
      element2 = csv_contents[0][(current_index + index)]
      expect(element2).to eq m[:id].gsub("/", "_").gsub("#", "_") + "_completed"
    end

    current_index += LearningModules::FOOD_ETALK.size

    VideoSurveys::MAP_VIDEOS_TO_SURVEYS.each_with_index do |vs, index|
      element = csv_contents[0][(current_index + index)]
      expect(element).to eq vs[:survey_args][:origin].gsub("-", "_").gsub("/", "_").gsub("#", "_") + "_started"
      current_index += 1
      element2 = csv_contents[0][(current_index + index)]
      expect(element2).to eq vs[:survey_args][:origin].gsub("-", "_").gsub("/", "_").gsub("#", "_") + "_completed"
    end

  end


  #validate row data

  it "deals with eligible flag true" do
    users = [eligible_user, ineligible_user]
    csv_string = subject.generate_report_as_csv(users, true)
    csv_contents = CSV.parse(csv_string)

    expect(csv_contents.size).to eq 2 #1 header row and 1 data row (exludes ineligble users)
    expect(csv_contents[1][6]).to eq "1"
  end


  it "deals with eligible flag false" do
    users = [eligible_user, ineligible_user]
    csv_string = subject.generate_report_as_csv(users, false)
    csv_contents = CSV.parse(csv_string)

    expect(csv_contents.size).to eq 2 #1 header row and 1 data row (exludes eligble users)
    expect(csv_contents[1][6]).to eq "0"
  end


  it "creates data values properly for user_has_completed_food_etalk" do

    FactoryBot.reload

    users = [user_has_completed_food_etalk]
    csv_string = subject.generate_report_as_csv(users)
    csv_contents = CSV.parse(csv_string)

    check_common_columns(csv_contents, users)

    current_index = 14

    RacialIdentity.all.each_with_index do |ri, index|
      if(ri.name == "white")
        element = csv_contents[1][(current_index + index)]
        expect(element).to eq "1"
      end
    end

    current_index += RacialIdentity.all.size

    FederalAssistance.all.each_with_index do |fa, index|
      element = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
    end

    current_index += FederalAssistance.all.size

    LearningModules::BETTER_U.each_with_index do |m, index|
      element = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
      current_index += 1
      element2 = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
    end

    current_index += LearningModules::BETTER_U.size

    LearningModules::FOOD_ETALK.each_with_index do |m, index|
      element = csv_contents[1][(current_index + index)]
      expect(element).to eq "1"
      current_index += 1
      element2 = csv_contents[1][(current_index + index)]
      expect(element).to eq "1"
    end

    current_index += LearningModules::FOOD_ETALK.size

    VideoSurveys::MAP_VIDEOS_TO_SURVEYS.each_with_index do |vs, index|
      element = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
      current_index += 1
      element2 = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
    end

  end

  it "creates data values properly for user_has_completed_better_u" do

    FactoryBot.reload

    users = [user_has_completed_better_u]
    csv_string = subject.generate_report_as_csv(users)
    csv_contents = CSV.parse(csv_string)

    check_common_columns(csv_contents, users)

    current_index = 14

    RacialIdentity.all.each_with_index do |ri, index|
      if(ri.name == "white")
        element = csv_contents[1][(current_index + index)]
        expect(element).to eq "1"
      end
    end

    current_index += RacialIdentity.all.size

    FederalAssistance.all.each_with_index do |fa, index|
      element = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
    end

    current_index += FederalAssistance.all.size

    LearningModules::BETTER_U.each_with_index do |m, index|
      element = csv_contents[1][(current_index + index)]
      expect(element).to eq "1"
      current_index += 1
      element2 = csv_contents[1][(current_index + index)]
      expect(element).to eq "1"
    end

    current_index += LearningModules::BETTER_U.size

    LearningModules::FOOD_ETALK.each_with_index do |m, index|
      element = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
      current_index += 1
      element2 = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
    end

    current_index += LearningModules::FOOD_ETALK.size

    VideoSurveys::MAP_VIDEOS_TO_SURVEYS.each_with_index do |vs, index|
      element = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
      current_index += 1
      element2 = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
    end

  end


  it "creates data values properly for user_has_started_video_survey_sweet_deceit" do

    FactoryBot.reload

    users = [user_has_started_video_survey_sweet_deceit]
    csv_string = subject.generate_report_as_csv(users)
    csv_contents = CSV.parse(csv_string)

    check_common_columns(csv_contents, users)

    current_index = 14

    RacialIdentity.all.each_with_index do |ri, index|
      if(ri.name == "white")
        element = csv_contents[1][(current_index + index)]
        expect(element).to eq "1"
      end
    end

    current_index += RacialIdentity.all.size

    FederalAssistance.all.each_with_index do |fa, index|
      element = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
    end

    current_index += FederalAssistance.all.size

    LearningModules::BETTER_U.each_with_index do |m, index|
      element = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
      current_index += 1
      element2 = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
    end

    current_index += LearningModules::BETTER_U.size

    LearningModules::FOOD_ETALK.each_with_index do |m, index|
      element = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
      current_index += 1
      element2 = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
    end

    current_index += LearningModules::FOOD_ETALK.size

    VideoSurveys::MAP_VIDEOS_TO_SURVEYS.each_with_index do |vs, index|
      header = csv_contents[0][(current_index + index)]
      element = csv_contents[1][(current_index + index)]

      if header == "sweet_deceit_started"
        expect(element).to eq "1"
      else
        expect(element).to eq "0"
      end

    end

  end

  it "creates data values properly for user_has_completed_video_survey_sweet_deceit" do

    FactoryBot.reload

    users = [user_has_completed_video_survey_sweet_deceit]
    csv_string = subject.generate_report_as_csv(users)
    csv_contents = CSV.parse(csv_string)

    check_common_columns(csv_contents, users)

    current_index = 14

    RacialIdentity.all.each_with_index do |ri, index|
      if(ri.name == "white")
        element = csv_contents[1][(current_index + index)]
        expect(element).to eq "1"
      end
    end

    current_index += RacialIdentity.all.size

    FederalAssistance.all.each_with_index do |fa, index|
      element = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
    end

    current_index += FederalAssistance.all.size

    LearningModules::BETTER_U.each_with_index do |m, index|
      element = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
      current_index += 1
      element2 = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
    end

    current_index += LearningModules::BETTER_U.size

    LearningModules::FOOD_ETALK.each_with_index do |m, index|
      element = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
      current_index += 1
      element2 = csv_contents[1][(current_index + index)]
      expect(element).to eq "0"
    end

    current_index += LearningModules::FOOD_ETALK.size

    VideoSurveys::MAP_VIDEOS_TO_SURVEYS.each_with_index do |vs, index|
      header = csv_contents[0][(current_index + index)]
      element = csv_contents[1][(current_index + index)]

      if((header == "sweet_deceit_started") || (header == "sweet_deceit_completed"))
        expect(element).to eq "1"
      else
        expect(element).to eq "0"
      end

    end

  end

  #ADD OTHER CASES FOR EXERCISE/COOKING VIDEOS?
  it "tests other videos" do
    #TODO IMPLEMENT ME!
  end


  private

  def check_common_columns(csv_contents, users)
    expect(csv_contents[1][0]).to eq "0" #"admin"
    expect(csv_contents[1][1]).to eq "0" #"group_admin"
    expect(csv_contents[1][2]).to eq "0" #"hancock-health-improvement-partnership"
    expect(csv_contents[1][3]).to eq "0" #"mercy-health-center"

    #using user_has_completed_food_etalk causes issues here...
    expect(csv_contents[1][4]).to eq users.first.created_at.to_s #"signup_date"

    expect(csv_contents[1][5]).to eq "uid|1" #"uid"
    expect(csv_contents[1][6]).to eq "1" #"is_eligible"
    expect(csv_contents[1][7]).to eq "Test" #"first_name"
    expect(csv_contents[1][8]).to eq "User" #"last_name"
    expect(csv_contents[1][9]).to eq "tester1@example.com" #"email"
    expect(csv_contents[1][10]).to eq "male" #"gender"
    expect(csv_contents[1][11]).to eq "21" #"age"
    expect(csv_contents[1][12]).to eq "30601" #"zip_code"
    expect(csv_contents[1][13]).to eq "false" #"is_hispanic_or_latino"
  end


end