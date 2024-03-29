class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :state
      t.string :suburb
      t.string :address
      t.string :post_code
      t.boolean :current_address, default: false
      t.datetime :valid_from, null: false
      t.datetime :valid_thru

      t.timestamps
    end
    add_index :addresses, %i[user_id valid_from valid_thru], unique: true
  end
end
