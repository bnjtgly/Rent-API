class CreateChatrooms < ActiveRecord::Migration[7.0]
  def change
    create_table :chatrooms, id: :uuid do |t|
      t.string :title
      t.references :sender, references: :users, foreign_key: { to_table: :users}, type: :uuid
      t.jsonb :participants, null: false, default: '{}'

      t.timestamps
    end
  end
end
