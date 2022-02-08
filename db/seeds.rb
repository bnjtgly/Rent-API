# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

api_client = ApiClient.create(name: 'Tenant Application Admin')
api_client2 = ApiClient.create(name: 'Tenant Application Web')
api_client3 = ApiClient.create(name: 'Tenant Application Ios')
api_client4 = ApiClient.create(name: 'Tenant Application Android')

role = Role.create(role_name: 'SUPERADMIN', role_def: 'Tenant Application super administrator.')
role2 = Role.create(role_name: 'USER', role_def: 'Tenant Application users/tenants.')

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SEED ON DEVELOPMENT, STAGING and PRODUCTION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# GLOBAL
ctrl_lvl = ControlLevel.create(sort_order: '100', control_level: 'Application', control_level_def: 'Access to all.')
ctrl_lvl2 = ControlLevel.create(sort_order: '200', control_level: 'Manager', control_level_def: 'Manager Access.')
ctrl_lvl3 = ControlLevel.create(sort_order: '300', control_level: 'User', control_level_def: 'User Access.')
ctrl_lvl4 = ControlLevel.create(sort_order: '400', control_level: 'Public', control_level_def: 'Public Access.')

gender = Domain.create(domain_number: 1001, control_level_id: ctrl_lvl3.id,  name: 'Gender', domain_def: 'Gender of user.')
gender_ref = DomainReference.create(sort_order: '100', domain_id: gender.id, control_level_id: ctrl_lvl3.id, display: 'Male', value_str: 'male')
DomainReference.create(sort_order: '200', domain_id: gender.id, control_level_id: ctrl_lvl3.id, display: 'Female', value_str: 'female')

user_status = Domain.create(domain_number: 1101, control_level_id: ctrl_lvl3.id, name: 'User Status', domain_def: 'Status of user.')
user_status_ref = DomainReference.create(sort_order: '100', domain_id: user_status.id, control_level_id: ctrl_lvl3.id, display: 'Active', value_str: 'active')
DomainReference.create(sort_order: '200', domain_id: user_status.id, control_level_id: ctrl_lvl3.id, display: 'Disabled', value_str: 'disabled')
DomainReference.create(sort_order: '300', domain_id: user_status.id, control_level_id: ctrl_lvl3.id, display: 'Banned', value_str: 'banned')
DomainReference.create(sort_order: '400', domain_id: user_status.id, control_level_id: ctrl_lvl.id, display: 'God', value_str: 'God')


sign_up_with = Domain.create(domain_number: 1201, control_level_id: ctrl_lvl3.id, name: 'Signup With', domain_def: 'Platform used in registration.')
sign_up_with_ref = DomainReference.create(sort_order: '100', domain_id: sign_up_with.id, control_level_id: ctrl_lvl3.id, display: 'Google', value_str: 'google')
sign_up_with_ref1 = DomainReference.create(sort_order: '200', domain_id: sign_up_with.id, control_level_id: ctrl_lvl3.id, display: 'Email', value_str: 'email')

mobile_country_code = Domain.create(domain_number: 1301, control_level_id: ctrl_lvl4.id, name: 'Mobile Country Code', domain_def: 'Mobile country code.')
mobile_country_code_ref = DomainReference.create(sort_order: '100', domain_id: mobile_country_code.id, control_level_id: ctrl_lvl4.id, display: '+61', value_str: '61',
                                                 metadata: { country: 'AU', image: 'https://advanceme-admin.s3.ap-southeast-1.amazonaws.com/public/domains/1003+-+Country/au-flag.png'})
mobile_country_code_ref2 = DomainReference.create(sort_order: '200', domain_id: mobile_country_code.id, control_level_id: ctrl_lvl3.id, display: '+63', value_str: '63',
                                                 metadata: { country: 'PH'})

# Create superadmin account
user = User.create(control_level_id: ctrl_lvl.id, email: 'superadmin@sr.tenant.com', password: '@Test123', first_name: 'Admin', last_name: 'Strator',
                   date_of_birth: '1993-01-01', mobile_country_code_id: mobile_country_code_ref.id, mobile: 9123456789,
                   refresh_token: SecureRandom.uuid, gender_id: gender_ref.id, api_client_id: api_client.id)
# Create user: tenant
user1 = User.create(control_level_id: ctrl_lvl3.id, email: 'jsmith@sr.tenant.com', password: 'Abc!23', first_name: 'John', last_name: 'Smith',
                    date_of_birth: '1994-10-10', sign_up_with_id: sign_up_with_ref1.id, mobile_country_code_id: mobile_country_code_ref.id,
                    mobile: 9123456790, refresh_token: SecureRandom.uuid, gender_id: gender_ref.id, api_client_id: api_client2.id)

# Assign role to user
UserRole.create(user_id: user.id, role_id: role.id)
UserRole.create(user_id: user1.id, role_id: role2.id)