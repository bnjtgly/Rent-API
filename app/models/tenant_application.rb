# frozen_string_literal: true

class TenantApplication < ApplicationRecord
  strip_attributes
  belongs_to :user
  belongs_to :property

  # Domain References Association
  # List all domain_references columns in users table.
  belongs_to :ref_status, class_name: 'DomainReference', foreign_key: 'tenant_application_status_id', optional: true
end
