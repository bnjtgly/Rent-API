FactoryBot.define do
  factory :domain_reference do
    association :domain
    role { nil }
    display { nil }
    value_str { display.downcase }
    status {'Active'}
  end
end