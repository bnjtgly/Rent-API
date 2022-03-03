# frozen_string_literal: true

class OtpVerification < ApplicationRecord
  strip_attributes
  belongs_to :user
  belongs_to :ref_mobile_country_code, class_name: 'DomainReference', foreign_key: 'mobile_country_code_id', optional: true

  audited associated_with: :user
end
