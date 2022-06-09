class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages, id: :uuid do |t|
      t.string :body, :limit => 10000
      t.references :chatroom, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.datetime :read_at

      t.timestamps
    end
  end
end
