class CreateDomainControlLevels < ActiveRecord::Migration[6.1]
  def change
    create_table :domain_control_levels, id: :uuid do |t|
      t.integer :sort_order
      t.string :control_level
      t.string :control_level_def

      t.timestamps
    end
  end
end
