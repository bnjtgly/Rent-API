class CreateDomainReferences < ActiveRecord::Migration[6.1]
  def change
    create_table :domain_references, id: :uuid do |t|
      t.references :domain, null: false, foreign_key: true, type: :uuid
      t.references :control_level, null: false, foreign_key: true, type: :uuid
      t.string :sort_order
      t.string :display
      t.string :value_str
      t.jsonb :metadata, null: false, default: '{}'
      t.string :status, default: 'Active'
      t.boolean :is_deleted, null: false, default: false

      t.timestamps
    end
  end
end
