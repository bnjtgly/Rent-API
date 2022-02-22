class CreateOtpVerifications < ActiveRecord::Migration[7.0]
  def change
    create_table :otp_verifications, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :mobile_country_code, references: :domain_references, foreign_key: { to_table: :domain_references}, type: :uuid
      t.bigint :mobile
      t.string :otp

      t.timestamps
    end
  end
end
