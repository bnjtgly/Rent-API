FactoryBot.define do
  factory :domain_reference do
    association :domain
    role { create(:role) }
    display { nil }
    value_str { nil }
  end
end