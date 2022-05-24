class CreateProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :properties, id: :uuid do |t|
      t.references :user_agency, null: false, foreign_key: true, type: :uuid
      t.jsonb :details, null: false, default: '{}'

      t.timestamps
    end
    add_index :properties, %i[user_agency_id details], unique: true
  end
end
