class Employment < ApplicationRecord
  strip_attributes
  belongs_to :income
  # has_one :reference, dependent: :destroy
  has_many :emp_documents, dependent: :destroy

  # Domain References Association
  # List all domain_references columns in users table.
  belongs_to :ref_employment_status, class_name: 'DomainReference', foreign_key: 'employment_status_id', optional: true
  belongs_to :ref_employment_type, class_name: 'DomainReference', foreign_key: 'employment_type_id', optional: true
end
