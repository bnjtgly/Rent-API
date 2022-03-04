# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
api_client_admin = ApiClient.create(name: 'Tenant Application Admin')
api_client_web = ApiClient.create(name: 'Tenant Application Web')
api_client_ios = ApiClient.create(name: 'Tenant Application Ios')
api_client_android = ApiClient.create(name: 'Tenant Application Android')

role_admin = Role.create(role_name: 'SUPERADMIN', role_def: 'Tenant Application super administrator.')
role_user = Role.create(role_name: 'USER', role_def: 'Tenant Application users/tenants.')
role_guest = Role.create(role_name: 'GUEST', role_def: 'Tenant Application guests/visitors.')

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SEED ON DEVELOPMENT, STAGING and PRODUCTION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# GLOBAL

user_gender = Domain.create(domain_number: 1001, name: 'User Gender', domain_def: 'Gender of user.')
user_gender_ref = DomainReference.create(sort_order: '100', domain_id: user_gender.id, role: %W[#{role_admin.id} #{role_user.id}], display: 'Male', value_str: 'male')
user_gender_ref2 = DomainReference.create(sort_order: '200', domain_id: user_gender.id, role: %W[#{role_admin.id} #{role_user.id}], display: 'Female', value_str: 'female')

user_status = Domain.create(domain_number: 1101, name: 'User Status', domain_def: 'Status of user.')
user_status_ref = DomainReference.create(sort_order: '100', domain_id: user_status.id, display: 'Active', value_str: 'active')
DomainReference.create(sort_order: '200', domain_id: user_status.id, role: %W[#{role_admin.id} #{role_user.id}], display: 'Disabled', value_str: 'disabled')
DomainReference.create(sort_order: '300', domain_id: user_status.id, role: %W[#{role_admin.id} #{role_user.id}], display: 'Banned', value_str: 'banned')

sign_up_with = Domain.create(domain_number: 1201, name: 'User Signup With', domain_def: 'Platform used in registration.')
sign_up_with_ref = DomainReference.create(sort_order: '100', domain_id: sign_up_with.id, role: %W[#{role_admin.id} #{role_user.id}], display: 'Google', value_str: 'google')
sign_up_with_ref1 = DomainReference.create(sort_order: '200', domain_id: sign_up_with.id, role: %W[#{role_admin.id} #{role_user.id}], display: 'Email', value_str: 'email')

mobile_country_code = Domain.create(domain_number: 1301, name: 'User Mobile Country Code', domain_def: 'Mobile country code.')
# Metadata image for testing only
mobile_country_code_ref = DomainReference.create(sort_order: '200', domain_id: mobile_country_code.id, role: %W[#{role_admin.id} #{role_user.id} #{role_guest.id}],
                                                 display: '+61', value_str: '61',
                                                 metadata: {
                                                   country: %w[AU Australia],
                                                   image: 'https://advanceme-admin.s3.ap-southeast-1.amazonaws.com/public/domains/1003+-+Country/au-flag.png'
                                                 })
# For development testing only
mobile_country_code_ref2 = DomainReference.create(sort_order: '100', domain_id: mobile_country_code.id, role: %W[#{role_admin.id} #{role_user.id} #{role_guest.id}],
                                                  display: '+63', value_str: '63',
                                                  metadata: {
                                                    country: %w[PH Philippines],
                                                    image: 'https://advanceme-admin.s3.ap-southeast-1.amazonaws.com/public/domains/1003+-+Country/ph-flag.png'
                                                  })

application_status = Domain.create(domain_number: 1401, name: 'Application Status', domain_def: 'Status of tenants application.')
application_status_ref1 = DomainReference.create(sort_order: '100', domain_id: application_status.id, role: %W[#{role_admin.id} #{role_user.id}], display: 'Accepted', value_str: 'accepted')
application_status_ref2 = DomainReference.create(sort_order: '200', domain_id: application_status.id, role: %W[#{role_admin.id} #{role_user.id}], display: 'Pending', value_str: 'pending')
DomainReference.create(sort_order: '300', domain_id: application_status.id, role: %W[#{role_admin.id} #{role_user.id}], display: 'Viewed', value_str: 'viewed')
DomainReference.create(sort_order: '400', domain_id: application_status.id, role: %W[#{role_admin.id} #{role_user.id}], display: 'Denied', value_str: 'denied')


case Rails.env
when 'development', 'staging'
  api_client_admin.update(api_key: '99ffe86f-ef93-4a12-be45-9e8c714e042a', secret_key: 'Ik4eHiqUivF-SqcUJdDUlQ')
  api_client_web.update(api_key: '295d1181-d22f-4e3c-b2e7-06a0d2e2e2e7', secret_key: '86M0tiX9iF_CsN-s5xdGMA')
  api_client_ios.update(api_key: 'ba1ea606-adc2-4d01-b3ed-3af2ad462628', secret_key: 'b9O70KcJrYucFARw1NLyjQ')
  api_client_android.update(api_key: '53ae18cf-6bfc-4837-84b5-a6073380f221', secret_key: 'Jmj0y-vYAX45Cs_67rqlPA')

  # SendgridTemplate
  SendgridTemplate.create(name: 'rento', version: 'v1', code: 'd-11741a7563124a79b1736dbdc78b5a78')

  # Create superadmin account
  user = User.create(email: 'superadmin@sr.tenant.com', password: '@Test123', first_name: 'Admin', last_name: 'Strator',
                     date_of_birth: '1993-01-01', mobile_country_code_id: mobile_country_code_ref.id, mobile: 9123456789, sign_up_with_id: sign_up_with_ref1.id,
                     refresh_token: SecureRandom.uuid, gender_id: user_gender_ref.id, api_client_id: api_client_admin.id, user_status_id: user_status_ref.id)

  # Create user: tenant - Web
  user1 = User.create(email: 'jsmith@sr.tenant.com', password: 'Abc!23', first_name: 'John', last_name: 'Smith', date_of_birth: '1994-10-10',
                      mobile_country_code_id: mobile_country_code_ref.id, mobile: 9123456790, is_email_verified: true, is_mobile_verified: true, sign_up_with_id: sign_up_with_ref1.id,
                      refresh_token: SecureRandom.uuid, gender_id: user_gender_ref.id, api_client_id: api_client_web.id, user_status_id: user_status_ref.id)

  # Create user: tenant - Ios
  user2 = User.create(email: 'aliciah@sr.tenant.com', password: 'Abc!23', first_name: 'Alicia', last_name: 'Henderson', date_of_birth: '1996-11-11',
                      mobile_country_code_id: mobile_country_code_ref.id, mobile: 7223456790, is_email_verified: true, is_mobile_verified: true, sign_up_with_id: sign_up_with_ref1.id,
                      refresh_token: SecureRandom.uuid, gender_id: user_gender_ref2.id, api_client_id: api_client_ios.id, user_status_id: user_status_ref.id)

  # Assign role to user
  UserRole.create(user_id: user.id, role_id: role_admin.id, audit_comment: 'Seed data.')
  UserRole.create(user_id: user1.id, role_id: role_user.id, audit_comment: 'Seed data.')
  UserRole.create(user_id: user2.id, role_id: role_user.id, audit_comment: 'Seed data.')

  OtpVerification.create(user_id: user1.id, mobile_country_code_id: mobile_country_code_ref.id, mobile: 9123456790, otp: 432098, audit_comment: 'Seed data.')

  # Testing database design

  property1 = Property.create(details: {
    id: SecureRandom.uuid,
    name: 'Treehouse hosted by Mikheyla Fox',
    desc: '',
    address: 'Dromana, Victoria, Australia',
    bedrooms: '5',
    bathrooms: '2',
    garage: '2',
    availability: '8',
    rent_per_week: '750'
  })

  property2 = Property.create(details: {
    id: SecureRandom.uuid,
    name: 'Resort Style Coastal Cottage - Walk to Beach',
    desc: '',
    address: 'Fourth Avenue, New Norfolk TAS, Australia',
    bedrooms: '4',
    bathrooms: '1',
    garage: '1',
    availability: '5',
    rent_per_week: '450'
  })

  UserProperty.create(user_id: user1.id, property_id: property1.id)
  UserProperty.create(user_id: user2.id, property_id: property1.id)
  UserProperty.create(user_id: user2.id, property_id: property2.id)

  TenantApplication.create(user_id: user1.id, property_id: property1.id, tenant_application_status_id: application_status_ref2.id)
  TenantApplication.create(user_id: user1.id, property_id: property2.id, tenant_application_status_id: application_status_ref2.id)
  TenantApplication.create(user_id: user2.id, property_id: property1.id, tenant_application_status_id: application_status_ref2.id)
else
  # type code here
end
