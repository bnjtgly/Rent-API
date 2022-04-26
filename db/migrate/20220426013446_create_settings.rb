class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings, id: :uuid do |t|
      t.string :name
      t.string :definition

      t.timestamps
    end
  end
end
