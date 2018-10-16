FactoryBot.define do
  factory :survey_history do
    sequence(:name) { |n| "Survey History #{n}" }
  end
end