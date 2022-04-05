FactoryBot.define do
  factory :user do
    association :api_client
    first_name { Faker::Name.first_name.gsub(/\W/, '').gsub("\u0000", '') }
    last_name { Faker::Name.last_name.gsub(/\W/, '').gsub("\u0000", '') }
    email { Faker::Internet.safe_email }
    password { alphanumeric_password }
  end
end

def alphanumeric_password
  password = ''
  until password =~ /\d/
    password = Faker::Internet.unique.password(min_length: 10, max_length: 20, mix_case: true, special_characters: true)
  end
  password
end