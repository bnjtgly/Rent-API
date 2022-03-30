FactoryBot.define do
  factory :user_role do
    association :role
    association :user
  end
end