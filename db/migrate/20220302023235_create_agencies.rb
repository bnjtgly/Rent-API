class CreateAgencies < ActiveRecord::Migration[7.0]
  def change
    create_table :agencies, id: :uuid do |t|
      t.string :name
      t.string :desc
      t.bigint :phone
      t.string :url

      t.timestamps
    end
  end
end
