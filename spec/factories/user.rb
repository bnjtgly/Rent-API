FactoryBot.define do
  factory :user do
    association :api_client
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password(min_length: 8, mix_case: true, special_characters: true) }
  end
end