class CreatePetVaccinations < ActiveRecord::Migration[7.0]
  def change
    create_table :pet_vaccinations, id: :uuid do |t|
      t.references :pet, null: false, foreign_key: true, type: :uuid
      t.references :pet_vaccine_type, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.datetime :vaccination_date
      t.string :proof

      t.timestamps
    end
  end
end
