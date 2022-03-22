class CreateEmpDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :emp_documents, id: :uuid do |t|
      t.references :employment, null: false, foreign_key: true, type: :uuid
      t.string :filename

      t.timestamps
    end
    add_index :emp_documents, %i[employment_id filename], unique: true
  end
end
