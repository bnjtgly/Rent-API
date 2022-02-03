class Authorization
  include Interactor

  delegate :headers, to: :context

  def call
    context.result = api_client
  end

  private

  def api_client
    if decoded_auth_token
      @api_client = ApiClient.where(api_key: decoded_auth_token[:api_key], is_deleted: false).first
      return @api_client if @api_client
    end

    context.fail!(error: decoded_auth_token)
    nil
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    else
      context.fail!(error: { token: ['Is Missing'] })
    end

    nil
  end
end
