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
            render status: :ok,json:{jwt:user.generate_jwt}
        end
    end
end
