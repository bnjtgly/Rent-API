class CreateUserSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :user_settings, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :setting, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.boolean :value, null: false, default: false

      t.timestamps
    end
    add_index :user_settings, %i[user_id setting_id], unique: true
  end
end
