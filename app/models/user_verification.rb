class UserVerification < ApplicationRecord
  strip_attributes
  belongs_to :user
  belongs_to :otp_verification

  audited associated_with: :user
end
