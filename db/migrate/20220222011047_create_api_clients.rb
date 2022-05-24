class CreateApiClients < ActiveRecord::Migration[7.0]
  def change
    create_table :api_clients, id: :uuid do |t|
      t.string :name
      t.string :api_key, limit: 36, null: false
      t.string :secret_key
      t.boolean :is_deleted, default: false

      t.timestamps
    end
    add_index :api_clients, %i[name api_key secret_key], unique: true
  end
end
