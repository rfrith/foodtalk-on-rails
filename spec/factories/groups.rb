FactoryBot.define do
  factory :group do

    trait :admin do
      name Group::ADMIN
      domain "admin.foodtalk.org"
      title "Foodtalk Admin Group"
    end

    trait :mhc do
      name "mercy-health-center"
      domain "mercy.foodtalk.org"
      title "Mercy Health Center"
    end

    trait :hhip do
      name "hancock-health-improvement-partnership"
      domain "hhip.foodtalk.org"
      title "Hanckock Health Improvement Partnership "
    end

  end
end