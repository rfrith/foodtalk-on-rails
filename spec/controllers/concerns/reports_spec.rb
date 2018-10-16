require 'rails_helper'

class CsvExport < ApplicationController
  include Reports
end

describe CsvExport do

  include_context "project setup"

  it "exports user data to csv properly" do

    users = [user_with_food_etalk_enrollment, user_with_better_u_enrollment, user_has_completed_food_etalk, user_has_completed_better_u]
    csv_string = subject.generate_report_as_csv(users)

    csv_contents = CSV.parse(csv_string)

    expect(csv_contents[0][0]).to eq "signup_date"
    expect(csv_contents[0][1]).to eq "uid"
    expect(csv_contents[0][2]).to eq "is_eligible"
    expect(csv_contents[0][3]).to eq "first_name"
    expect(csv_contents[0][4]).to eq "last_name"
    expect(csv_contents[0][5]).to eq "email"
    expect(csv_contents[0][6]).to eq "gender"
    expect(csv_contents[0][7]).to eq "age"
    expect(csv_contents[0][8]).to eq "zip_code"
    expect(csv_contents[0][9]).to eq "is_hispanic_or_latino"

    #csv_contents[0].size

    current_index = 10

    RacialIdentity.all.each_with_index do |ri, index|
      expect(csv_contents[0][current_index + index]).to eq ri.name.parameterize.underscore
    end

    FederalAssistance.all.each_with_index do |fa, index|
      expect(csv_contents[0][current_index + index]).to eq fa.name.parameterize.underscore
    end

    LearningModules::BETTER_U.each_with_index do |m, index|
      #expect(csv_contents[0][current_index + index]).to eq m[:id].gsub("/", "_").gsub("#", "_") + "_started"
      #expect(csv_contents[0][(current_index + index)]).to eq m[:id].gsub("/", "_").gsub("#", "_") + "_completed"
    end

    LearningModules::FOOD_ETALK.each_with_index do |m, index|
      #expect(csv_contents[0][current_index + index]).to eq m[:id].gsub("/", "_").gsub("#", "_") + "_started"
      #expect(csv_contents[0][current_index += index]).to eq m[:id].gsub("/", "_").gsub("#", "_") + "_completed"
    end

    VideoSurveys::MAP_VIDEOS_TO_SURVEYS.each_with_index do |vs, index|
      #expect(csv_contents[0][current_index += index]).to eq vs[:survey_args][:origin].gsub("-", "_").gsub("/", "_").gsub("#", "_") + "_started"
      #expect(csv_contents[0][current_index += index]).to eq vs[:survey_args][:origin].gsub("-", "_").gsub("/", "_").gsub("#", "_") + "_completed"
    end









    #CSV.parse(csv_string) { |row|
    #  puts row.inspect
    #}

  end

end