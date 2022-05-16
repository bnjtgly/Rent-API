class CreateUserProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :user_properties, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :property, null: false, foreign_key: true, type: :uuid
      t.boolean :is_applied, default: false

      t.timestamps
    end
  end
end
