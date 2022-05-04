FactoryBot.define do
  factory :property do
    association :user_agency
    details { '{}' }
  end
end