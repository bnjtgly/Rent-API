class UserSetting < ApplicationRecord
  strip_attributes
  belongs_to :user

  # Domain References Association
  # List all domain_references columns in users table.
  belongs_to :ref_setting, class_name: 'DomainReference', foreign_key: 'setting_id', optional: true

  audited associated_with: :user
end
