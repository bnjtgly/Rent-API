# frozen_string_literal: true

module Api
  class CreateTenantApplication
    include Interactor

    delegate :data, :current_user, to: :context

    def call
      validate!
      build
    end

    def rollback
      context.tenant_application&.destroy
    end

    private

    def build
      @tenant_application = TenantApplication.new(payload)
      @application_summary = Api::ProfileSummaryService.new(current_user).call
      @tenant_application_status = DomainReference.joins(:domain)
                                                  .where(domains: { domain_number: 1401 }, domain_references: { value_str: 'pending' }).load_async.first

      # Remove in production
      # For RSpec
      unless %w[test].any? { |keyword| Rails.env.include?(keyword) }
        @tenant_application.tenant_application_status_id = @tenant_application_status.id
        @tenant_application.application_data = @application_summary
      end

      TenantApplication.transaction do
        @tenant_application.save
      end

      @user_property = UserProperty.where(property_id: @tenant_application.property.id, user_id: current_user.id)
                                   .update(is_applied: true)

      context.tenant_application = @tenant_application
    end

    def validate!
      verify = Api::CreateTenantApplicationValidator.new(payload)
      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        audit_comment: 'Create Tenant Application',
        user_id: current_user.id,
        property_id: data[:tenant_application][:property_id],
        flatmate_id: data[:tenant_application][:flatmate_id],
        lease_length_id: data[:tenant_application][:lease_length_id],
        lease_start_date: data[:tenant_application][:lease_start_date],
      }
    end
  end
end
