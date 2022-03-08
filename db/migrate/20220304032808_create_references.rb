class CreateReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :references, id: :uuid do |t|
      t.references :address,foreign_key: true, type: :uuid
      t.references :employment,foreign_key: true, type: :uuid
      t.references :mobile_country_code, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.references :ref_position, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.string :full_name
      t.string :email
      t.bigint :mobile

      t.timestamps
    end
  end
end
