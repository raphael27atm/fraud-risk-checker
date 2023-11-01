# frozen_string_literal: true

require 'jwt'

class JsonWebToken
  class << self
    def encode(payload)
      JWT.encode(payload, ENV['API_SECRET_KEY'])
    end

    def decode(token)
      JWT.decode(
        token,
        ENV['API_SECRET_KEY'],
        true,
        { verify_expiration: false }
      )
    end
  end
end

