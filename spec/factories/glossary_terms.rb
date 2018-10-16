FactoryBot.define do
  factory :glossary_term do
    sequence(:name) { |n| "Glossary Term #{n}" }
    description "Test Term"
    source "Test Source"
    remote_image_url "https://via.placeholder.com/350x150"
  end
end