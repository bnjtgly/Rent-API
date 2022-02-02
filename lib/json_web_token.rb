# frozen_string_literal: true

class JsonWebToken
  class << self

    # def encode_5minutes(payload)
    #   # set token expiration time
    #   exp = 5.minutes.from_now
    #   payload[:exp] = exp.to_i
    #
    #   # this encodes the user data(payload) with our secret key
    #   JWT.encode(payload, Rails.application.secret_key_base)
    # end
    #
    # def encode_1hour(payload)
    #   # set token expiration time
    #   exp = 1.hour.from_now
    #   payload[:exp] = exp.to_i
    #
    #   # this encodes the user data(payload) with our secret key
    #   JWT.encode(payload, Rails.application.secret_key_base)
    # end

    def encode_24hours(payload)
      # set token expiration time
      exp = 24.hours.from_now
      payload[:exp] = exp.to_i

      # this encodes the user data(payload) with our secret key
      JWT.encode(payload, Rails.application.secret_key_base)
    end

    def decode(token)
      # decodes the token to get user data (payload)
      body = JWT.decode(token, Rails.application.secret_key_base)[0]
      HashWithIndifferentAccess.new body
    rescue StandardError
      nil
    end

    def read(token)
      # decodes the token to get user data (payload)
      body = JWT.decode(token, Rails.application.secret_key_base, false)[0]
      HashWithIndifferentAccess.new body
    rescue StandardError
      nil
    end
  end
end
