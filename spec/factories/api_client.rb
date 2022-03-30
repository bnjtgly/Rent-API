FactoryBot.define do
  factory :api_client do
    name { Faker::Company.name }
  end
end