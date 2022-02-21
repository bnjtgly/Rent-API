module AdminApi
  class CreateDomain
    include Interactor

    delegate :data, to: :context

    def call
      validate!
      build
    end

    def rollback
      context.domain&.destroy
    end

    private

    def build
      @domain = Domain.new(payload)
      Domain.transaction do
        @domain.save
      end

      context.domain = @domain
    end

    def validate!
      verify = AdminApi::CreateDomainValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        domain_number: data[:domain][:domain_number],
        name: data[:domain][:name],
        domain_def: data[:domain][:domain_def]
      }
    end
  end
end
