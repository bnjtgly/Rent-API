class CreateIncomes < ActiveRecord::Migration[7.0]
  def change
    create_table :incomes, id: :uuid do |t|

      t.timestamps
    end
  end
end
