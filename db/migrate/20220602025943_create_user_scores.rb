class CreateUserScores < ActiveRecord::Migration[7.0]
  def change
    create_table :user_scores, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :score_category_type, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.string :desc
      t.float :score
      t.string :remark

      t.timestamps
    end
    add_index :user_scores, %i[user_id score_category_type_id], unique: true
  end
end
