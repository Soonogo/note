class User < ApplicationRecord
    validates :email, presence: true

    def generate_jwt
        payload = { user_id: self.id ,exp:(Time.now+2.hours).to_i}
        return JWT.encode payload, Rails.application.credentials.hmac_secret, 'HS256'
    end
    def generate_jwt_header
        return {Authorization:"Bearer #{self.generate_jwt}"}
    end
end
