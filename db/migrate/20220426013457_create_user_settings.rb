class CreateUserSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :user_settings, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :setting, null: false, foreign_key: true, type: :uuid
      t.boolean :value, null: false, default: false

      t.timestamps
    end
  end
end
