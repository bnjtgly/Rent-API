class CreateAgencies < ActiveRecord::Migration[7.0]
  def change
    create_table :agencies, id: :uuid do |t|
      t.references :mobile_country_code, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.string :email, null: false, default: ''
      t.string :name
      t.bigint :mobile
      t.bigint :phone
      t.jsonb :addresses, null: false, default: '{}'
      t.jsonb :links, null: false, default: '{}'

      t.timestamps
    end
    add_index :agencies, %i[name phone], unique: true
  end
end
