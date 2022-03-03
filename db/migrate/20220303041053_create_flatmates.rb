class CreateFlatmates < ActiveRecord::Migration[7.0]
  def change
    create_table :flatmates, id: :uuid do |t|

      t.timestamps
    end
  end
end
