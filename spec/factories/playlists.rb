FactoryBot.define do
  factory :playlist do
    name { "MyString" }
    position { 1 }
    type { 1 }
    user_id { 1 }
    playlist_item_id { 1 }
  end
end
