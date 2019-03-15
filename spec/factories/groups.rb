FactoryBot.define do
  factory :group do

    trait :mhc do
      name {"mercy-health-center"}
      domain {"mercy.foodtalk.org"}
      title {"Mercy Health Center"}
    end

    trait :hhip do
      name {"hancock-health-improvement-partnership"}
      domain {"hhip.foodtalk.org"}
      title {"Hanckock Health Improvement Partnership"}
    end

  end
end