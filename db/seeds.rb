# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

api_client = ApiClient.create(name: 'Tenant Application Admin')
api_client2 = ApiClient.create(name: 'Tenant Application Ios')
api_client3 = ApiClient.create(name: 'Tenant Application Android')

role1 = Role.create(name: 'SUPERADMIN', role_def: 'Tenant Application super administrator.')
role3 = Role.create(name: 'USER', role_def: 'Tenant Application users/tenants.')