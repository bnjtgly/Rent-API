module AdminApi
  class UpdateDomainReference
    include Interactor

    delegate :data, to: :context

    def call
      validate!
      build
    end

    def rollback; end

    private

    def build
      @domain_reference = DomainReference.where(id: payload[:domain_reference_id]).first

      @domain_reference&.update(
        role: payload[:role],
        sort_order: payload[:sort_order],
        display: payload[:display],
        value_str: payload[:value_str],
        status: payload[:status],
        is_deleted: payload[:is_deleted],
        metadata: payload[:metadata]
      )

      context.domain_reference = @domain_reference
    end

    def validate!
      verify = AdminApi::UpdateDomainReferenceValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        domain_reference_id: data[:domain_reference_id],
        role: data[:domain_reference][:role],
        sort_order: data[:domain_reference][:sort_order],
        display: data[:domain_reference][:display],
        value_str: data[:domain_reference][:value_str],
        status: data[:domain_reference][:status],
        is_deleted: data[:domain_reference][:is_deleted],
        metadata: data[:domain_reference][:metadata]
      }
    end
  end
end
