class CreateUserAgencies < ActiveRecord::Migration[7.0]
  def change
    create_table :user_agencies, id: :uuid do |t|
      t.references :host, references: :users, foreign_key: { to_table: :users}, type: :uuid
      t.references :agency, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :user_agencies, %i[host_id agency_id], unique: true
  end
end
