class CreateTenantApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :tenant_applications, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :property, null: false, foreign_key: true, type: :uuid
      t.references :tenant_application_status, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.jsonb :application_data, null: false, default: '{}'

      t.timestamps
    end
  end
end
