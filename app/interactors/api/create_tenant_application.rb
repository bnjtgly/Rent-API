# frozen_string_literal: true

module Api
  class CreateTenantApplication
    include Interactor

    delegate :data, :current_user, to: :context

    def call
      init
      validate!
      build
    end

    def rollback
      context.tenant_application&.destroy
    end

    private

    def init
      @user = User.where(id: current_user.id).first
      context.fail!(error: { profile: ['Please try again. Complete your profile first.'] }) unless is_profile_complete?
    end

    def build
      @tenant_application = TenantApplication.new(payload.except(:cover_letter))
      property = Property.where(id: payload[:property_id]).first
      @application_summary = Api::ProfileSummaryService.new(current_user, property, payload[:flatmate_id], payload[:cover_letter]).call
      @tenant_application_status = DomainReference.joins(:domain)
                                                  .where(domains: { domain_number: 1401 }, domain_references: { value_str: 'pending' }).load_async.first

      # Remove in production
      # For RSpec
      unless %w[test].any? { |keyword| Rails.env.include?(keyword) }
        @tenant_application.tenant_application_status_id = @tenant_application_status.id
        @tenant_application.application_data = @application_summary
      end

      # @todo: Check if all profile details are present.
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
        user_id: @user.id,
        property_id: data[:tenant_application][:property_id],
        flatmate_id: data[:tenant_application][:flatmate_id] ? data[:tenant_application][:flatmate_id] : nil,
        lease_length_id: data[:tenant_application][:lease_length_id],
        lease_start_date: data[:tenant_application][:lease_start_date],
        cover_letter: data[:tenant_application][:application_data][:cover_letter]
      }
    end

    def is_profile_complete?
      return true if @user.addresses.present? && @user.identities.present? && @user.incomes.present? && @user.pets.present?

      false
    end
  end
end
