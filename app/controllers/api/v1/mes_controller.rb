class Api::V1::MesController < ApplicationController
    def show
        user_id = request.env["current_user_id"]
        user = User.find_by_id(user_id)
        if user.nil?
            return head 400
        else
            render status: :ok,json:{resource:user}

        end
    end
end
