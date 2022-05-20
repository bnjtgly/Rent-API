# frozen_string_literal: true

class TenantApplication < ApplicationRecord
  strip_attributes
  belongs_to :user
  belongs_to :property
  belongs_to :flatmate, optional: true
  has_many :tenant_application_histories

  # Domain References Association
  # List all domain_references columns in users table.
  belongs_to :ref_status, class_name: 'DomainReference', foreign_key: 'tenant_application_status_id', optional: true
  belongs_to :ref_lease_length, class_name: 'DomainReference', foreign_key: 'lease_length_id', optional: true

  audited associated_with: :user

  after_create_commit :notify_recipient

  private

  def notify_recipient
    TenantApplicationNotification.with(tenant_application: self, user: user).deliver_later(property.user_agency.host)
  end
end
