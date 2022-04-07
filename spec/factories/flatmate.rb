FactoryBot.define do
  factory :flatmate do
    association :user
    group_name { Faker::Team.name }
  end
end