module AdminApi
  class CreateDomainReference
    include Interactor

    delegate :data, to: :context

    def call
      validate!
      build
    end

    def rollback
      context.domain_reference&.destroy
    end

    private

    def build
      @domain_reference = DomainReference.new(payload)
      DomainReference.transaction do
        @domain_reference.save
      end

      context.domain_reference = @domain_reference
    end

    def validate!
      verify = AdminApi::CreateDomainReferenceValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        domain_id: data[:domain_reference][:domain_id],
        role: data[:domain_reference][:role],
        sort_order: data[:domain_reference][:sort_order],
        display: data[:domain_reference][:display],
        value_str: data[:domain_reference][:value_str],
        status: data[:domain_reference][:status],
        metadata: data[:domain_reference][:metadata]
      }
    end
  end
end
