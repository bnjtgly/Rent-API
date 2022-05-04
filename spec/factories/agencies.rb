FactoryBot.define do
  factory :agency do
    name { Faker::Team.name }
    desc { Faker::Quote.famous_last_words }
    phone { Faker::PhoneNumber.phone_number }
    url { Faker::Internet.url }
  end
end
