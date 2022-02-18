class CreateSendgridTemplates < ActiveRecord::Migration[6.1]
  def change
    create_table :sendgrid_templates, id: :uuid do |t|
      t.string :name
      t.string :version
      t.string :code

      t.timestamps
    end
  end
end
