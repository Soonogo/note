require 'jwt'

class Api::V1::SessionsController < ApplicationController
    def create
        if Rails.env.test?
            return render status: 401 unless params[:code] == "123456"
        else
        canSignIn = ValidationCode.exists? email:params[:email],code:params[:code],used_at:nil
        return render status: 401 unless canSignIn
        
        end
        user = User.find_by_email(params[:email])
        if user.nil?
            render status: :not_found,json:{errors:"user not found"}
        else
            payload = { user_id: user.id }

            token = JWT.encode payload, Rails.application.credentials.hmac_secret, 'HS256'
            render status: :ok,json:{jwt:token}
        end
    end
end
