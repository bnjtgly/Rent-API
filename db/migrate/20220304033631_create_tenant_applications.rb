class CreateTenantApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :tenant_applications, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :property, null: false, foreign_key: true, type: :uuid
      t.references :flatmate, foreign_key: true, type: :uuid
      t.references :lease_length, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.references :tenant_application_status, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.datetime :lease_start_date
      t.jsonb :application_data, null: false, default: '{}'

      t.timestamps
    end
    add_index :tenant_applications, %i[user_id property_id], unique: true
  end
end