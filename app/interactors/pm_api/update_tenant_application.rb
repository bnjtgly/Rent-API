module PmApi
  class UpdateTenantApplication
  include Interactor

  delegate :data, :current_user, to: :context

    def call
      validate!
      build
    end

    def rollback; end

    private
    def build
      @tenant_application = TenantApplication.where(id: payload[:tenant_application_id]).first

      @tenant_application&.update(
        tenant_application_status_id: payload[:tenant_application_status_id]
        )
    end

    def validate!
      verify = PmApi::UpdateTenantApplicationValidator.new(payload)
      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        tenant_application_id: data[:tenant_application_id],
        tenant_application_status_id: data[:tenant_application][:tenant_application_status_id]
      }
    end
  end
end
