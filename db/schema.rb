# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_03_07_014148) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "state"
    t.string "suburb"
    t.string "address"
    t.string "post_code"
    t.datetime "move_in_date"
    t.datetime "move_out_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "api_clients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "api_key", limit: 36, null: false
    t.string "secret_key"
    t.boolean "is_deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.uuid "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "domain_references", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "domain_id", null: false
    t.string "role", array: true
    t.string "sort_order"
    t.string "display"
    t.string "value_str"
    t.jsonb "metadata", default: "{}", null: false
    t.string "status", default: "Active"
    t.boolean "is_deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_id", "display", "value_str"], name: "index_domain_references_on_domain_id_and_display_and_value_str", unique: true
    t.index ["domain_id"], name: "index_domain_references_on_domain_id"
  end

  create_table "domains", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "domain_number"
    t.string "name"
    t.string "domain_def"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_number"], name: "index_domains_on_domain_number", unique: true
  end

  create_table "emp_documents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "employment_id", null: false
    t.string "filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employment_id"], name: "index_emp_documents_on_employment_id"
  end

  create_table "employments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "income_id", null: false
    t.uuid "employment_status_id"
    t.uuid "employment_type_id"
    t.string "company_name"
    t.string "position"
    t.integer "tenure"
    t.float "net_income"
    t.string "state"
    t.string "suburb"
    t.string "address"
    t.string "post_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employment_status_id"], name: "index_employments_on_employment_status_id"
    t.index ["employment_type_id"], name: "index_employments_on_employment_type_id"
    t.index ["income_id"], name: "index_employments_on_income_id"
  end

  create_table "flatmates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "full_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_flatmates_on_user_id"
  end

  create_table "identities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "identity_type_id"
    t.string "filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_type_id"], name: "index_identities_on_identity_type_id"
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "incomes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "income_source_id"
    t.uuid "income_frequency_id"
    t.uuid "currency_id"
    t.float "amount"
    t.string "proof"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_id"], name: "index_incomes_on_currency_id"
    t.index ["income_frequency_id"], name: "index_incomes_on_income_frequency_id"
    t.index ["income_source_id"], name: "index_incomes_on_income_source_id"
    t.index ["user_id"], name: "index_incomes_on_user_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "otp_verifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "mobile_country_code_id"
    t.bigint "mobile"
    t.string "otp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mobile_country_code_id"], name: "index_otp_verifications_on_mobile_country_code_id"
    t.index ["user_id"], name: "index_otp_verifications_on_user_id"
  end

  create_table "pets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "pet_type_id"
    t.uuid "pet_gender_id"
    t.uuid "pet_weight_id"
    t.string "name"
    t.string "breed"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pet_gender_id"], name: "index_pets_on_pet_gender_id"
    t.index ["pet_type_id"], name: "index_pets_on_pet_type_id"
    t.index ["pet_weight_id"], name: "index_pets_on_pet_weight_id"
    t.index ["user_id"], name: "index_pets_on_user_id"
  end

  create_table "properties", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "details", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "references", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "address_id"
    t.uuid "employment_id"
    t.uuid "mobile_country_code_id"
    t.uuid "ref_position_id"
    t.string "full_name"
    t.string "email"
    t.bigint "mobile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_references_on_address_id"
    t.index ["employment_id"], name: "index_references_on_employment_id"
    t.index ["mobile_country_code_id"], name: "index_references_on_mobile_country_code_id"
    t.index ["ref_position_id"], name: "index_references_on_ref_position_id"
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "role_name"
    t.string "role_def"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_name"], name: "index_roles_on_role_name", unique: true
  end

  create_table "sendgrid_templates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "version"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tenant_application_histories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tenant_application_id", null: false
    t.jsonb "application_data", default: "{}", null: false
    t.integer "version"
    t.datetime "valid_from", default: -> { "now()" }, null: false
    t.datetime "valid_thru"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_application_id"], name: "index_tenant_application_histories_on_tenant_application_id"
  end

  create_table "tenant_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "property_id", null: false
    t.uuid "tenant_application_status_id"
    t.jsonb "application_data", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_tenant_applications_on_property_id"
    t.index ["tenant_application_status_id"], name: "index_tenant_applications_on_tenant_application_status_id"
    t.index ["user_id"], name: "index_tenant_applications_on_user_id"
  end

  create_table "user_properties", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "property_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_user_properties_on_property_id"
    t.index ["user_id"], name: "index_user_properties_on_user_id"
  end

  create_table "user_roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.uuid "api_client_id", null: false
    t.uuid "gender_id"
    t.uuid "mobile_country_code_id"
    t.uuid "sign_up_with_id"
    t.uuid "user_status_id"
    t.string "first_name"
    t.string "last_name"
    t.datetime "date_of_birth"
    t.bigint "mobile"
    t.string "phone"
    t.string "avatar"
    t.string "refresh_token"
    t.boolean "is_email_verified", default: false
    t.boolean "is_mobile_verified", default: false
    t.string "is_email_verified_token"
    t.string "otp"
    t.datetime "otp_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_client_id"], name: "index_users_on_api_client_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["gender_id"], name: "index_users_on_gender_id"
    t.index ["mobile_country_code_id"], name: "index_users_on_mobile_country_code_id"
    t.index ["sign_up_with_id"], name: "index_users_on_sign_up_with_id"
    t.index ["user_status_id"], name: "index_users_on_user_status_id"
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "domain_references", "domains"
  add_foreign_key "emp_documents", "employments"
  add_foreign_key "employments", "domain_references", column: "employment_status_id"
  add_foreign_key "employments", "domain_references", column: "employment_type_id"
  add_foreign_key "employments", "incomes"
  add_foreign_key "flatmates", "users"
  add_foreign_key "identities", "domain_references", column: "identity_type_id"
  add_foreign_key "identities", "users"
  add_foreign_key "incomes", "domain_references", column: "currency_id"
  add_foreign_key "incomes", "domain_references", column: "income_frequency_id"
  add_foreign_key "incomes", "domain_references", column: "income_source_id"
  add_foreign_key "incomes", "users"
  add_foreign_key "otp_verifications", "domain_references", column: "mobile_country_code_id"
  add_foreign_key "otp_verifications", "users"
  add_foreign_key "pets", "domain_references", column: "pet_gender_id"
  add_foreign_key "pets", "domain_references", column: "pet_type_id"
  add_foreign_key "pets", "domain_references", column: "pet_weight_id"
  add_foreign_key "pets", "users"
  add_foreign_key "references", "addresses"
  add_foreign_key "references", "domain_references", column: "mobile_country_code_id"
  add_foreign_key "references", "domain_references", column: "ref_position_id"
  add_foreign_key "references", "employments"
  add_foreign_key "tenant_application_histories", "tenant_applications"
  add_foreign_key "tenant_applications", "domain_references", column: "tenant_application_status_id"
  add_foreign_key "tenant_applications", "properties"
  add_foreign_key "tenant_applications", "users"
  add_foreign_key "user_properties", "properties"
  add_foreign_key "user_properties", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "users", "api_clients"
  add_foreign_key "users", "domain_references", column: "gender_id"
  add_foreign_key "users", "domain_references", column: "mobile_country_code_id"
  add_foreign_key "users", "domain_references", column: "sign_up_with_id"
  add_foreign_key "users", "domain_references", column: "user_status_id"
end
