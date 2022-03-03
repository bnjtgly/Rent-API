class CreateReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :references, id: :uuid do |t|

      t.timestamps
    end
  end
end
