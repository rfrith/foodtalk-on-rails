FactoryBot.define do
  factory :federal_assistance do
    sequence(:id) { |n| n }
    sequence(:name) { |n| "Federal Assistance |#{n}" }
    initialize_with { FederalAssistance.where(:id => id).first_or_create }

    trait :tanf do
      name "tanf"
    end

  end
end