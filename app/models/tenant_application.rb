# frozen_string_literal: true

class TenantApplication < ApplicationRecord
  strip_attributes
  belongs_to :user
  belongs_to :property
  belongs_to :flatmate, optional: true
  has_many :tenant_application_histories

  has_noticed_notifications

  # Domain References Association
  # List all domain_references columns in users table.
  belongs_to :ref_status, class_name: 'DomainReference', foreign_key: 'tenant_application_status_id', optional: true
  belongs_to :ref_lease_length, class_name: 'DomainReference', foreign_key: 'lease_length_id', optional: true

  audited associated_with: :user

  after_commit :notify_property_manager, :notify_tenant, on: [:create, :update]

  private
  def notify_tenant
    application_serializer = Api::NotificationService.new({ tenant_application: self }).call
    TenantApplicationNotification.with(type: 'TenantApplicationNotification', tenant_application: application_serializer).deliver_later(user)
  end
  def notify_property_manager
    application_serializer = PmApi::NotificationService.new({ tenant_application: self }).call
    @hosts = User.includes(:user_agency).where(user_agency: { agency_id: property.agency_id })

    # Notify all PMs in the agency.
    TenantApplicationNotification.with(type: 'TenantApplicationNotification', tenant_application: application_serializer).deliver_later(@hosts)
  end

end
