class CreateOtpVerifications < ActiveRecord::Migration[6.1]
  def change
    create_table :otp_verifications, id: :uuid do |t|
      t.integer :mobile_country_code
      t.bigint :mobile
      t.string :otp

      t.timestamps
    end
  end
end
