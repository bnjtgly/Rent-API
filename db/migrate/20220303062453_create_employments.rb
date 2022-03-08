class CreateEmployments < ActiveRecord::Migration[7.0]
  def change
    create_table :employments, id: :uuid do |t|
      t.references :income, null: false, foreign_key: true, type: :uuid
      t.references :employment_status, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.references :employment_type, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.string :company_name
      t.string :position
      t.integer :tenure
      t.float :net_income
      t.string :address

      t.timestamps
    end
  end
end
