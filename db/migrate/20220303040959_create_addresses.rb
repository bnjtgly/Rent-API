class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :state
      t.string :suburb
      t.string :address
      t.integer :post_code
      t.datetime :move_in_date
      t.datetime :move_out_date

      t.timestamps
    end
    add_index :addresses, %i[user_id address], unique: true
    add_index :addresses, %i[move_in_date move_out_date], unique: true
  end
end
