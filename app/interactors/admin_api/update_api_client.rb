module AdminApi
  class UpdateApiClient
    include Interactor

    delegate :data, to: :context

    def call
      validate!
      build
    end

    def rollback; end

    private

    def build
      @api_client = ApiClient.where(id: payload[:api_client_id], is_deleted: false).first

      @api_client&.update(
        name: payload[:name]
      )
    end

    def validate!
      verify = AdminApi::UpdateApiClientValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        api_client_id: data[:api_client_id],
        name: data[:api_client][:name]
      }
    end
  end
end