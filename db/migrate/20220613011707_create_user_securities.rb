class CreateUserSecurities < ActiveRecord::Migration[7.0]
  def change
    create_table :user_securities, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.boolean :sms_notification, default: true

      t.timestamps
    end
  end
end
