class CreatePets < ActiveRecord::Migration[7.0]
  def change
    create_table :pets, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :pet_type, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.references :pet_gender, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.references :pet_weight, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.references :pet_vaccine_type, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.string :name
      t.string :breed
      t.string :color
      t.datetime :vaccination_date
      t.string :proof

      t.timestamps
    end
    add_index :pets, %i[user_id pet_type_id name], unique: true
  end
end
