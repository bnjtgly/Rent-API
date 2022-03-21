class CreateFlatmateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :flatmate_members, id: :uuid do |t|
      t.references :flatmate, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :flatmate_members, %i[flatmate_id user_id], unique: true
  end
end
