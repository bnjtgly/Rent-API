module AdminApi
  class DestroyDomainReference
    include Interactor

    delegate :data, :id, to: :context

    def call
      init
      validate!
      build
    end

    def rollback; end

    private
    def init
      @domain_references = DomainReference.where(id: id).first
    end

    def build
      if @domain_references
        @domain_references.update(is_deleted: true)
      else
        context.fail!(error: { id: ['Please try again. Domain reference not found.'] })
      end
    end

    def validate!
      verify = AdminApi::DestroyDomainReferenceValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        domain_reference: @domain_references
      }
    end
  end
end
