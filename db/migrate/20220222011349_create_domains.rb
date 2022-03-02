class CreateDomains < ActiveRecord::Migration[7.0]
  def change
    create_table :domains, id: :uuid do |t|
      t.integer :domain_number
      t.string :name
      t.string :domain_def

      t.timestamps
    end
    add_index :domains, :domain_number, unique: true
  end
end
