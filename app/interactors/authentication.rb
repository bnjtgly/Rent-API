class Authentication
  include Interactor

  delegate :api_key, :secret_key, to: :context

  def call
    @api_client = ApiClient.where(api_key: api_key, secret_key: secret_key).first

    return context.token = JsonWebToken.encode_24hours(api_key: @api_client.api_key) if @api_client

    context.fail!(error: { authentication: ['Invalid Credentials'] })
    nil
  end
end
