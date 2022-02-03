# frozen_string_literal: true

class RefreshUserToken
  include Interactor

  delegate :headers, to: :context

  def call
    if refresh_me
      if refresh_me.role_name.eql?('SUPERADMIN')
        context.token = JsonWebToken.encode_24hours(refresh_token: decoded_auth_token[:refresh_token],
                                                    sub: decoded_auth_token[:sub],
                                                    scp: decoded_auth_token[:scp],
                                                    aud: decoded_auth_token[:aud],
                                                    iat: Time.now.to_i,
                                                    jti: decoded_auth_token[:jti])
      else
        context.token = JsonWebToken.encode_5minutes(refresh_token: decoded_auth_token[:refresh_token],
                                                     sub: decoded_auth_token[:sub],
                                                     scp: decoded_auth_token[:scp],
                                                     aud: decoded_auth_token[:aud],
                                                     iat: Time.now.to_i,
                                                     jti: decoded_auth_token[:jti])
      end
    end
  end

  private

  def refresh_me
    if decoded_auth_token
      @user = UserRole.joins(:user, :role).where(user: {id: decoded_auth_token[:sub]}).select('*').first
      @jwt_denylist = JwtDenylist.where(jti: decoded_auth_token[:jti]).first

      ap decoded_auth_token[:refresh_token]

      if !@jwt_denylist.nil?
        context.fail!(error: { user: ['Access denied!. Token has expired. Already logged out.'] })
      elsif @user && @user.refresh_token.eql?(decoded_auth_token[:refresh_token])
        @user
      else
        context.fail!(error: { user: ['Access denied!. Refresh token is invalid.'] })
      end
    else
      context.fail!(error: { user: ['Access denied!. Token is invalid.'] })
    end
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.read(http_auth_header)
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
