class TenantApplicationHistory < ApplicationRecord
  strip_attributes
  belongs_to :tenant_application

  # Domain References Association
  # List all domain_references columns in users table.
  belongs_to :ref_application_status, class_name: 'DomainReference', foreign_key: 'application_status_id', optional: true
end
