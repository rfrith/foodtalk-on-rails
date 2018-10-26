FactoryBot.define do
  factory :survey_history do
    sequence(:name) { |n| "Survey History #{n}" }
  end

  trait :sweet_deceit_started do
    name "sweet-deceit#started"
  end

  trait :sweet_deceit_completed do
    name "sweet-deceit#completed"
  end

end