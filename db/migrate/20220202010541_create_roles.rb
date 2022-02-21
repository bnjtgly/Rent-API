class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles, id: :uuid do |t|
      t.string :role_name
      t.string :role_def

      t.timestamps
    end
    add_index :roles, :role_name, unique: true
  end
end
