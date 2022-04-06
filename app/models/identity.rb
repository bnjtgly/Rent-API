# frozen_string_literal: true

class Identity < ApplicationRecord
  strip_attributes
  # encrypts :id_number, deterministic: true
  mount_base64_uploader :file, IdentityUploader

  belongs_to :user

  # Domain References Association
  # List all domain_references columns in users table.
  belongs_to :ref_identity_type, class_name: 'DomainReference', foreign_key: 'identity_type_id', optional: true

  audited associated_with: :user
end
