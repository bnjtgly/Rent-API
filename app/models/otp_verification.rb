class OtpVerification < ApplicationRecord
  strip_attributes
  belongs_to :user

  audited associated_with: :user
end
