module AdminApi
  class UpdateDomain
    include Interactor

    delegate :data, to: :context

    def call
      validate!
      build
    end

    def rollback; end

    private

    def build
      @domain = Domain.where(id: payload[:domain_id]).first

      @domain&.update(
        domain_number: payload[:domain_number],
        name: payload[:name],
        domain_def: payload[:domain_def]
      )
    end

    def validate!
      verify = AdminApi::UpdateDomainValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        domain_id: data[:domain_id],
        domain_number: data[:domain][:domain_number],
        name: data[:domain][:name],
        domain_def: data[:domain][:domain_def]
      }
    end
  end
end
