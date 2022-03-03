class CreatePets < ActiveRecord::Migration[7.0]
  def change
    create_table :pets, id: :uuid do |t|

      t.timestamps
    end
  end
end
