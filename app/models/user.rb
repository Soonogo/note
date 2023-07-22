class User < ApplicationRecord
    validates :email, presence: true

    def generate_jwt
        payload = { user_id: self.id }
        return JWT.encode payload, Rails.application.credentials.hmac_secret, 'HS256'
    end
    def generate_jwt_header
        return {Authorization:"Bearer #{self.generate_jwt}"}
    end
end
