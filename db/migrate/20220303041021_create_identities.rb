class CreateIdentities < ActiveRecord::Migration[7.0]
  def change
    create_table :identities, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :identity_type, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.string :id_number
      t.string :file

      t.timestamps
    end
    add_index :identities, %i[user_id identity_type_id id_number], unique: true
  end
end
