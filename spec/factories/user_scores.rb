FactoryBot.define do
  factory :user_score do
    user { nil }
    desc { "MyString" }
    score { 1.5 }
    remark { "MyString" }
  end
end
