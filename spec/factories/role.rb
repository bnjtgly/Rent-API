FactoryBot.define do
  factory :role do
    role_name { 'USER' }
    role_def { 'Tenant Application users/tenants.' }
  end
end