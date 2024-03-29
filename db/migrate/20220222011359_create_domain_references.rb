class CreateDomainReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :domain_references, id: :uuid do |t|
      t.references :domain, null: false, foreign_key: true, type: :uuid
      t.string :role, array: true
      t.string :sort_order
      t.string :display
      t.string :value_str
      t.jsonb :metadata, null: false, default: '{}'
      t.string :status, default: 'Active'
      t.boolean :is_deleted, null: false, default: false

      t.timestamps
    end
    add_index :domain_references, %i[domain_id display value_str], unique: true
  end
end
