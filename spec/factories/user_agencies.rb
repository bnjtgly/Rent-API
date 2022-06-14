FactoryBot.define do
  factory :user_agency do
    association :agency
    association :user, :factory => :user
  end
end
