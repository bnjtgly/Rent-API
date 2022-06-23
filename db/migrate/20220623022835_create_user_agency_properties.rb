class CreateUserAgencyProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :user_agency_properties, id: :uuid do |t|
      t.references :user_agency, null: false, foreign_key: true, type: :uuid
      t.references :property, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
