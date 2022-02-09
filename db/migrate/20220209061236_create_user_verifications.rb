class CreateUserVerifications < ActiveRecord::Migration[6.1]
  def change
    create_table :user_verifications, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :otp_verification, null: false, foreign_key: true, type: :uuid
      t.boolean :is_mobile_verified, default: false
      t.boolean :is_email_verified, default: false
      t.string :is_email_verified_token
      t.string :otp
      t.datetime :otp_sent_at
      
      t.timestamps
    end
  end
end
