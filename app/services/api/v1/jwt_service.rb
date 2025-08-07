require "jwt"

module Api
  module V1
    class JwtService
      SECRET_KEY = Rails.application.credentials.secret_key_base
      ALGORITHM = "HS256"

      def self.encode(payload)
        JWT.encode(payload, SECRET_KEY, ALGORITHM)
      end

      def self.decode(token)
        JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })[0].with_indifferent_access
      rescue JWT::DecodeError
        nil
      end
    end
  end
end
