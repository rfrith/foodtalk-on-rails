FactoryBot.define do
  factory :racial_identity do

    id 1

    sequence(:name) { |n| "Racial Identity #{n}" }

    initialize_with { RacialIdentity.where(:id => id).first_or_create }

    trait :white do
      name "white"
    end

    trait :black do
      name "black"
    end

  end
end
