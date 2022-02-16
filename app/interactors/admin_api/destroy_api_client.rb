module AdminApi
  class DestroyApiClient
    include Interactor

    delegate :id, to: :context

    def call
      build
    end

    def rollback; end

    private

    def build
      @api_client = ApiClient.where(id: id).first
      if @api_client
        @api_client.update_columns(is_deleted: true)
      else
        context.fail!(error: { id: ['Please try again. API Client not found.'] })
      end
    end
  end
end