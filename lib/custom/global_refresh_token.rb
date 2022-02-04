module Custom
  module GlobalRefreshToken
    def login_refresh_token(token)
      @token = token
      if login_refresh_me
        if login_refresh_me.role_name.eql?('SUPERADMIN')
          JsonWebToken.encode_24hours(refresh_token: decoded_auth_token[:refresh_token],
                                      sub: decoded_auth_token[:sub],
                                      scp: decoded_auth_token[:scp],
                                      aud: decoded_auth_token[:aud],
                                      iat: Time.now.to_i,
                                      jti: decoded_auth_token[:jti])
        else
          JsonWebToken.encode_5minutes(refresh_token: decoded_auth_token[:refresh_token],
                                       sub: decoded_auth_token[:sub],
                                       scp: decoded_auth_token[:scp],
                                       aud: decoded_auth_token[:aud],
                                       iat: Time.now.to_i,
                                       jti: decoded_auth_token[:jti])
        end
      end
    end

    def login_refresh_me
      if decoded_auth_token
        @user = UserRole.joins(:user, :role).where(user: {id: decoded_auth_token[:sub]}).select('*').first
        @jwt_denylist = JwtDenylist.where(jti: decoded_auth_token[:jti]).first

        if @user && @user.refresh_token.eql?(decoded_auth_token[:refresh_token])
          @user
        end
      end
    end

    def decoded_auth_token
      @decoded_auth_token ||= JsonWebToken.read(http_auth_header)
    end

    def http_auth_header
      if @token.present?
        return @token.split(' ').last
      end
      nil
    end
  end
end
