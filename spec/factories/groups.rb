FactoryBot.define do
  factory :group do
    name Group::ADMIN
    domain "admin.foodtalk.org"
    title "Foodtalk Admin Group"
  end
end