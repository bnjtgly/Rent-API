class UserScore < ApplicationRecord
  strip_attributes
  belongs_to :user

  # Domain References Association
  # List all domain_references columns in users table.
  belongs_to :ref_score_category_type, class_name: 'DomainReference', foreign_key: 'score_category_type_id', optional: true

  audited associated_with: :user
end
