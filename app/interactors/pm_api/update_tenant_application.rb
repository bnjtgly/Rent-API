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
      @tenant_application = TenantApplication.where(id: payload[:tenant_application_id]).load_async.first
      @tenant_application_history = TenantApplicationHistory.where(tenant_application_id: payload[:tenant_application_id]).load_async

      @tenant_application&.update(
        tenant_application_status_id: payload[:tenant_application_status_id]
      )

      @tenant_application.tenant_application_histories.update(valid_thru: Time.now.utc)
      @tenant_application.tenant_application_histories.create(
        application_status_id: @tenant_application.tenant_application_status_id,
        version: @tenant_application_history.nil? ? 0 : @tenant_application_history.count + 1,
        application_data: @tenant_application.application_data,
        valid_thru: nil
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
