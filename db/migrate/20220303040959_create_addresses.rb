class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :state
      t.string :suburb
      t.string :address
      t.string :post_code
      # t.datetime :move_in_date
      # t.datetime :move_out_date
      t.datetime :valid_from, null: false
      t.datetime :valid_thru

      t.timestamps
    end
  end
end
