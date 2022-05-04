FactoryBot.define do
  factory :user_agency do
    association :agency
    association :host, :factory => :user
  end
end
