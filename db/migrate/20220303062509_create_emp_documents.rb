class CreateEmpDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :emp_documents, id: :uuid do |t|
      t.references :employment, null: false, foreign_key: true, type: :uuid
      t.references :document_type, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.string :file

      t.timestamps
    end
    add_index :emp_documents, %i[employment_id file], unique: true
  end
end
