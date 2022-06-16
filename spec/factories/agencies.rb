FactoryBot.define do
  factory :agency do
    name { Faker::Team.name }
    email { Faker::Internet.safe_email }
    mobile_country_code_id { nil }
    mobile { Faker::PhoneNumber.subscriber_number(length: 10) }
    phone { Faker::PhoneNumber.phone_number }
    links {
      {
        facebook: "fb.com/#{name.gsub(' ', '').downcase}",
        linkedin: "linkedin.com/#{name.gsub(' ', '').downcase}",
        twitter: "twitter.com/#{name.gsub(' ', '').downcase}"
      }
    }
    addresses { [
      { state: Faker::Address.state, address: Faker::Address.full_address }
    ] }
  end
end


