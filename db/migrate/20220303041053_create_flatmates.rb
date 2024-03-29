class CreateFlatmates < ActiveRecord::Migration[7.0]
  def change
    create_table :flatmates, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :group_name

      t.timestamps
    end
    add_index :flatmates, %i[user_id group_name], unique: true
  end
end
