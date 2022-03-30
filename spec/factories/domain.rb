FactoryBot.define do
  factory :domain do
    domain_number { Faker::Number.binary }
    name {nil}
  end
end