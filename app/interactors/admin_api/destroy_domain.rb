module AdminApi
  class DestroyDomain
    include Interactor

    delegate :id, to: :context

    def call
      build
    end

    def rollback; end

    private

    def build
      @domain = Domain.where(id: id).load_async.first
      @domain_references = DomainReference.where(domain_id: id).load_async.first
      if @domain
        if @domain_references
          context.fail!(error: { id: ['This Domain is used in Domain References'] })
        else
          @domain.destroy
        end
      else
        context.fail!(error: { id: ['Please try again. Domain not found.'] })
      end
    end
  end
end
