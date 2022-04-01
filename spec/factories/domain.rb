FactoryBot.define do
  factory :domain do
    domain_number { Faker::Number.unique.binary }
    name {nil}
  end
end