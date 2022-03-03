class CreateEmployments < ActiveRecord::Migration[7.0]
  def change
    create_table :employments, id: :uuid do |t|

      t.timestamps
    end
  end
end
