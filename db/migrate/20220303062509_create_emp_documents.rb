class CreateEmpDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :emp_documents, id: :uuid do |t|

      t.timestamps
    end
  end
end
