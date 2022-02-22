class CreateSendgridTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :sendgrid_templates, id: :uuid do |t|
      t.string :name
      t.string :version
      t.string :code

      t.timestamps
    end
  end
end
