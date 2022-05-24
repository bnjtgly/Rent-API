# frozen_string_literal: true

module PmApi
  class UpdateTenantApplicationValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :tenant_application_id,
      :tenant_application_status_id
    )

    validate :tenant_application_id_exist, :required, :valid_tenant_application_status_id

    def submit
      init
      persist!
    end

    private

    def init
      @tenant_application = TenantApplication.where(id: tenant_application_id).first
    end

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:tenant_application_id, REQUIRED_MESSAGE) if tenant_application_id.blank?
      errors.add(:tenant_application_status_id, REQUIRED_MESSAGE) if tenant_application_status_id.blank?
    end

    def tenant_application_id_exist
      errors.add(:user_id, NOT_FOUND) unless @tenant_application
    end

    def valid_tenant_application_status_id
      unless tenant_application_status_id.blank?
        domain_reference = DomainReference.joins(:domain).where(domains: { domain_number: 1401 },
                                                                domain_references: { id: tenant_application_status_id }).first
        unless domain_reference
          references = DomainReference.joins(:domain).where(domains: { domain_number: 1401 },
                                                            domain_references: { status: 'Active' })
          errors.add(:tenant_application_status_id, "#{PLEASE_CHANGE_MESSAGE} Valid values are #{references.pluck(:value_str).to_sentence}.")
        end
      end
    end

  end
end
