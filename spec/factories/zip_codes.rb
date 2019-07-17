FactoryBot.define do
  factory :zip_code do

    trait :eligible do
      zip {30601}
      eligible { true }
    end

    trait :ineligible do
      zip {30621}
      eligible { false }
    end

  end
end