class CreateTenantApplicationHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :tenant_application_histories, id: :uuid do |t|
      t.references :tenant_application, null: false, foreign_key: true, type: :uuid
      t.references :application_status, references: :domain_references, foreign_key: { to_table: :domain_references }, type: :uuid
      t.jsonb :application_data, null: false, default: '{}'
      t.integer :version
      t.datetime :valid_from, null: false, default: -> { 'NOW()' }
      t.datetime :valid_thru

      t.timestamps
    end
  end
end
