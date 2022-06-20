class EmpDocument < ApplicationRecord
  strip_attributes
  mount_base64_uploader :file, EmploymentUploader

  belongs_to :employment

  # Domain References Association
  # List all domain_references columns in users table.
  belongs_to :ref_document_type, class_name: 'DomainReference', foreign_key: 'document_type_id', optional: true
end
