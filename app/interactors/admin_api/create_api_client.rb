module AdminApi
  class CreateApiClient
    include Interactor

    delegate :data, to: :context

    def call
      validate!
      build
    end

    def rollback
      context.api_client&.destroy
    end

    private

    def build
      @api_client = ApiClient.new(payload)
      ApiClient.transaction do
        @api_client.save
      end

      context.api_client = @api_client
    end

    def validate!
      verify = AdminApi::CreateApiClientValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        name: data[:api_client][:name]
      }
    end
  end
end
