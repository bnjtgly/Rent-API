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
  specials = ((35..38).to_a + (91..96).to_a).pack('U*').chars.to_a
  characters = specials
  password = Random.new.rand(1..2).times.map{characters.sample}
  password << Faker::Internet.password(min_length: 15, mix_case: true)
  password << specials.sample unless password.join =~ Regexp.new(Regexp.escape(specials.join))
  password.shuffle.join
end