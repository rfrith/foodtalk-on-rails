FactoryBot.define do
  factory :federal_assistance do
    sequence(:name) { |n| "Federal Assistance #{n}" }

    id 1
    initialize_with { FederalAssistance.where(:id => id).first_or_create }

  end
end