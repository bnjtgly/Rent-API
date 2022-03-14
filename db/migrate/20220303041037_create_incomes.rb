class CreateIncomes < ActiveRecord::Migration[7.0]
  def change
    create_table :incomes, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :income_source, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.references :income_frequency, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.references :currency, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.float :amount
      t.string :proof

      t.timestamps
    end
  end
end
