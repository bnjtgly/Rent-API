class CreateEmployments < ActiveRecord::Migration[7.0]
  def change
    create_table :employments, id: :uuid do |t|
      t.references :income, null: false, foreign_key: true, type: :uuid
      t.string :company_name
      t.string :position
      t.integer :tenure
      t.string :state
      t.string :suburb
      t.string :address
      t.string :post_code

      t.timestamps
    end
    add_index :employments, %i[income_id company_name], unique: true
  end
end
