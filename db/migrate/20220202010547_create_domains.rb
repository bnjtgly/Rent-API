class CreateDomains < ActiveRecord::Migration[6.1]
  def change
    create_table :domains, id: :uuid do |t|
      t.references :domain_control_level, null: false, foreign_key: true, type: :uuid
      t.integer :domain_number
      t.string :name
      t.string :domain_def
      # t.string :sector, default: 'PRIVATE'

      t.timestamps
    end
  end
end
