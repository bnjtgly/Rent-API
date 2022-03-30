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
application_status_ref2 = DomainReference.create(sort_order: '200', domain_id: application_status.id, role: %W[#{role_admin.id} #{role_user.id}], display: 'Reviewed', value_str: 'reviewed')
application_status_ref3 = DomainReference.create(sort_order: '300', domain_id: application_status.id, role: %W[#{role_admin.id} #{role_user.id}], display: 'Pending', value_str: 'pending')
DomainReference.create(sort_order: '400', domain_id: application_status.id, role: %W[#{role_admin.id} #{role_user.id}], display: 'Rejected', value_str: 'rejected')
DomainReference.create(sort_order: '500', domain_id: application_status.id, role: %W[#{role_admin.id} #{role_user.id}], display: 'Draft', value_str: 'draft')
DomainReference.create(sort_order: '600', domain_id: application_status.id, role: %W[#{role_admin.id} #{role_user.id}], display: 'Closed', value_str: 'closed')

# Identities
identity_type = Domain.create(domain_number: 1501, name: 'Identity Type', domain_def: 'Identity ID type.')
identity_type_ref = DomainReference.create(sort_order: '100', domain_id: identity_type.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Driver's License", value_str: 'driver license')
DomainReference.create(sort_order: '200', domain_id: identity_type.id, role: %W[#{role_admin.id} #{role_user.id}], display: 'Australian Passport', value_str: 'australian passport')
DomainReference.create(sort_order: '300', domain_id: identity_type.id, role: %W[#{role_admin.id} #{role_user.id}], display: 'Overseas Passport', value_str: 'overseas passport')

# Incomes
income_source = Domain.create(domain_number: 1601, name: 'Income Source', domain_def: 'Source of income.')
income_source_ref = DomainReference.create(sort_order: '100', domain_id: income_source.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Salary", value_str: 'salary')
income_source_ref2 = DomainReference.create(sort_order: '200', domain_id: income_source.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Allowance", value_str: 'allowance')
DomainReference.create(sort_order: '300', domain_id: income_source.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Pension", value_str: 'pension')
DomainReference.create(sort_order: '400', domain_id: income_source.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Overtime", value_str: 'overtime')
DomainReference.create(sort_order: '500', domain_id: income_source.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Commission", value_str: 'commission')
DomainReference.create(sort_order: '600', domain_id: income_source.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Bonus", value_str: 'bonus')

income_frequency = Domain.create(domain_number: 1701, name: 'Income Frequency', domain_def: 'Frequency of income.')
income_frequency_ref = DomainReference.create(sort_order: '100', domain_id: income_frequency.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Weekly", value_str: 'weekly')
DomainReference.create(sort_order: '200', domain_id: income_frequency.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Fortnightly", value_str: 'fortnightly')
income_frequency_ref2 = DomainReference.create(sort_order: '300', domain_id: income_frequency.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Monthly", value_str: 'monthly')
DomainReference.create(sort_order: '400', domain_id: income_frequency.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Yearly", value_str: 'yearly')

# Pets
pet_type = Domain.create(domain_number: 1801, name: 'Pet Type', domain_def: 'Type of pet.')
pet_type_ref = DomainReference.create(sort_order: '100', domain_id: pet_type.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Dog", value_str: 'dog')
DomainReference.create(sort_order: '200', domain_id: pet_type.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Cat", value_str: 'cat')
DomainReference.create(sort_order: '300', domain_id: pet_type.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Bird", value_str: 'bird')
DomainReference.create(sort_order: '400', domain_id: pet_type.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Rabbit", value_str: 'rabbit')
DomainReference.create(sort_order: '500', domain_id: pet_type.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Pig", value_str: 'pig')
DomainReference.create(sort_order: '600', domain_id: pet_type.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Fish", value_str: 'fish')

pet_gender = Domain.create(domain_number: 1901, name: 'Pet Gender', domain_def: 'Gender of pet.')
pet_gender_ref = DomainReference.create(sort_order: '100', domain_id: pet_gender.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Male", value_str: 'male')
DomainReference.create(sort_order: '200', domain_id: pet_gender.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Female", value_str: 'Female')

pet_weight = Domain.create(domain_number: 2001, name: 'Pet Weight', domain_def: 'Weight of pet.')
pet_weight_ref = DomainReference.create(sort_order: '100', domain_id: pet_weight.id, role: %W[#{role_admin.id} #{role_user.id}], display: "0-10 kg", value_str: '0-10kg')
DomainReference.create(sort_order: '200', domain_id: pet_weight.id, role: %W[#{role_admin.id} #{role_user.id}], display: "11-25 kg", value_str: '11-25kg')
DomainReference.create(sort_order: '300', domain_id: pet_weight.id, role: %W[#{role_admin.id} #{role_user.id}], display: "26-50 kg", value_str: '26-50kg')
DomainReference.create(sort_order: '400', domain_id: pet_weight.id, role: %W[#{role_admin.id} #{role_user.id}], display: "51+ kg", value_str: '51+kg')

# Employments
employment_status = Domain.create(domain_number: 2101, name: 'Employment Status', domain_def: 'Status of employment.')
employment_status_ref = DomainReference.create(sort_order: '100', domain_id: employment_status.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Employed", value_str: 'employed')

employment_type = Domain.create(domain_number: 2201, name: 'Employment Type', domain_def: 'Type of employment.')
employment_type_ref = DomainReference.create(sort_order: '100', domain_id: employment_type.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Full-time", value_str: 'full-time')
DomainReference.create(sort_order: '200', domain_id: employment_type.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Part-time", value_str: 'part-time')
DomainReference.create(sort_order: '300', domain_id: employment_type.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Casual", value_str: 'casual')

# Referencens
ref_add_position = Domain.create(domain_number: 2301, name: 'Employment Reference Position', domain_def: 'Position of the referenced person.')
ref_add_position_ref1 = DomainReference.create(sort_order: '100', domain_id: ref_add_position.id, role: %W[#{role_admin.id} #{role_user.id}], display: "CEO", value_str: 'ceo')

ref_emp_position = Domain.create(domain_number: 2401, name: 'Address Reference Position', domain_def: 'Position of the referenced person.')
DomainReference.create(sort_order: '100', domain_id: ref_emp_position.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Property Manager", value_str: 'property manager')
ref_emp_position_ref2 = DomainReference.create(sort_order: '200', domain_id: ref_emp_position.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Land Lord", value_str: 'land lord')
DomainReference.create(sort_order: '300', domain_id: ref_emp_position.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Broker", value_str: 'team leader')
DomainReference.create(sort_order: '400', domain_id: ref_emp_position.id, role: %W[#{role_admin.id} #{role_user.id}], display: "Appraiser", value_str: 'Appraiser')

currency = Domain.create(domain_number: 2501, name: 'Currency', domain_def: 'Currency.')
currency_ref = DomainReference.create(sort_order: '100', domain_id: currency.id, role: %W[#{role_admin.id} #{role_user.id}], display: 'A$', value_str: 'AUD',
                       metadata: { country: 'AU' })
currency_ref2 = DomainReference.create(sort_order: '200', domain_id: currency.id, role: %W[#{role_admin.id} #{role_user.id}], display: '$', value_str: 'USD',
                       metadata: { country: 'US' })

# Application
lease_length = Domain.create(domain_number: 2601, name: 'Lease Length', domain_def: 'Length of lease.')
lease_length_ref1 = DomainReference.create(sort_order: '100', domain_id: lease_length.id, role: %W[#{role_admin.id} #{role_user.id}], display: "12 Months", value_str: '12')
DomainReference.create(sort_order: '200', domain_id: lease_length.id, role: %W[#{role_admin.id} #{role_user.id}], display: "24 Months", value_str: '24')
DomainReference.create(sort_order: '300', domain_id: lease_length.id, role: %W[#{role_admin.id} #{role_user.id}], display: "36 Months", value_str: '36')
DomainReference.create(sort_order: '400', domain_id: lease_length.id, role: %W[#{role_admin.id} #{role_user.id}], display: "48 Months", value_str: '48')


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

  user3 = User.create(email: 'agnespaige@sr.tenant.com', password: 'Abc!23', first_name: 'Agnes', last_name: 'Paige', date_of_birth: '1992-12-10',
                      mobile_country_code_id: mobile_country_code_ref.id, mobile: 7233456792, is_email_verified: true, is_mobile_verified: true, sign_up_with_id: sign_up_with_ref1.id,
                      refresh_token: SecureRandom.uuid, gender_id: user_gender_ref2.id, api_client_id: api_client_web.id, user_status_id: user_status_ref.id)

  # Create user: tenant - Ios
  user2 = User.create(email: 'aliciah@sr.tenant.com', password: 'Abc!23', first_name: 'Alicia', last_name: 'Henderson', date_of_birth: '1996-11-11',
                      mobile_country_code_id: mobile_country_code_ref.id, mobile: 7223456790, is_email_verified: true, is_mobile_verified: true, sign_up_with_id: sign_up_with_ref1.id,
                      refresh_token: SecureRandom.uuid, gender_id: user_gender_ref2.id, api_client_id: api_client_ios.id, user_status_id: user_status_ref.id)

  # Assign role to user
  UserRole.create(user_id: user.id, role_id: role_admin.id, audit_comment: 'Seed data.')
  UserRole.create(user_id: user1.id, role_id: role_user.id, audit_comment: 'Seed data.')
  UserRole.create(user_id: user2.id, role_id: role_user.id, audit_comment: 'Seed data.')
  UserRole.create(user_id: user3.id, role_id: role_user.id, audit_comment: 'Seed data.')

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
    availability: '2022-03-22',
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
    availability: '2022-01-22',
    rent_per_week: '450'
  })

  property3 = Property.create(details: {
    id: SecureRandom.uuid,
    name: 'Master Bedroom on private level + & W.I.R!',
    desc: '',
    address: 'Fourth Avenue, New Norfolk TAS, Australia',
    bedrooms: '4',
    bathrooms: '1',
    garage: '1',
    availability: '2022-01-22',
    rent_per_week: '430'
  })

  property4 = Property.create(details: {
    id: SecureRandom.uuid,
    name: 'Little Cottage by the River in Healesville',
    desc: '',
    address: 'Fourth Avenue, New Norfolk TAS, Australia',
    bedrooms: '3',
    bathrooms: '1',
    garage: '1',
    availability: '2022-04-22',
    rent_per_week: '370'
  })

  # User saved properties.
  UserProperty.create(user_id: user1.id, property_id: property1.id)
  UserProperty.create(user_id: user1.id, property_id: property2.id)
  UserProperty.create(user_id: user2.id, property_id: property1.id)

  # Sample Tenant Application
  address1 = Address.create(user_id: user1.id,
                            state: 'Tasmania',
                            suburb: 'New Norfolk',
                            address: 'Address 1',
                            post_code: '7140',
                            valid_from: '2020-01-01',
                            valid_thru: '2021-03-01')
  Reference.create(address_id: address1.id,
                   full_name: 'Adam Smith',
                   email: 'adamsmith@go.team.au',
                   ref_position_id: ref_add_position_ref1.id,
                   mobile_country_code_id: mobile_country_code_ref.id,
                   mobile: 412345678)

  Identity.create(user_id: user1.id, identity_type_id: identity_type_ref.id, id_number: 'B01194', file: 'driver_license.jpg')

  flatmate = Flatmate.create(user_id: user1.id, group_name: 'Friends')
  FlatmateMember.create(flatmate_id: flatmate.id, user_id: user2.id)
  FlatmateMember.create(flatmate_id: flatmate.id, user_id: user3.id)

  Pet.create(user_id: user1.id,
             pet_type_id: pet_type_ref.id,
             pet_gender_id: pet_gender_ref.id,
             pet_weight_id: pet_weight_ref.id,
             name: 'Miffie',
             breed: 'Shi Zhu',
             color: 'Brown')

  income1 = Income.create(user_id: user1.id,
                          income_source_id: income_source_ref2.id,
                          income_frequency_id: income_frequency_ref.id,
                          currency_id: currency_ref.id,
                          amount: 500,
                          proof: 'receipt.jpg')

  emp1 = Employment.create(income_id: income1.id,
                           employment_status_id: employment_status_ref.id,
                           employment_type_id: employment_type_ref.id,
                           company_name: 'Go Team',
                           position: 'Developer',
                           tenure: 1,
                           net_income: 500,
                           state: 'Tasmania',
                           suburb: 'New Norfolk',
                           address: '5 Que Road',
                           post_code: '7140')

  EmpDocument.create(employment_id: emp1.id, file: 'payslip.jpg')
  EmpDocument.create(employment_id: emp1.id, file: 'coe.jpg')

  Reference.create(address_id: address1.id,
                   full_name: 'Joanna Miller',
                   email: 'jmiller@go.team.au',
                   ref_position_id: ref_emp_position_ref2.id,
                   mobile_country_code_id: mobile_country_code_ref.id,
                   mobile: 712345689)

  TenantApplication.create(user_id: user1.id, property_id: property1.id, flatmate_id: flatmate.id, lease_length_id: lease_length_ref1.id, lease_start_date: '2022-03-01', tenant_application_status_id: application_status_ref2.id)
  TenantApplication.create(user_id: user1.id, property_id: property2.id, flatmate_id: flatmate.id, lease_length_id: lease_length_ref1.id, lease_start_date: '2022-03-01', tenant_application_status_id: application_status_ref2.id)
  TenantApplication.create(user_id: user2.id, property_id: property1.id, tenant_application_status_id: application_status_ref2.id)

else
  # type code here
end
