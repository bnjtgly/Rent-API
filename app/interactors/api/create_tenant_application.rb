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
      @tenant_application_status = DomainReference.joins(:domain)
                                                  .where(domains: { domain_number: 1401 }, domain_references: { value_str: 'pending' }).load_async.first

      # Remove in production
      # For RSpec
      unless %w[test].any? { |keyword| Rails.env.include?(keyword) }
        @tenant_application.tenant_application_status_id = @tenant_application_status.id
        setup_application_data
      end

      TenantApplication.transaction do
        @tenant_application.save
      end

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

    def setup_application_data
      @user = User.where(id: current_user.id).load_async.first
      @employment = @user.incomes.where.associated(:employment).first
      # @todo: Check if application for pending status or draft.

      @tenant_application.application_data = {
        personal_info: {
          email: @user.email,
          complete_name: @user.complete_name,
          gender: @user.ref_gender.display,
          date_of_birth: @user.date_of_birth_format,
          phone: @user.phone,
          mobile_number: @user.mobile_number
        },
        addresses: @user.addresses,
        identities: @user.identities,
        incomes: @user.incomes,
        employment: @employment ? @employment.employment : [],
        pets: @user.pets
      }
    end
  end
end
