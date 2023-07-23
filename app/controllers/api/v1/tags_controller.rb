class Api::V1::TagsController < ApplicationController
    def index
        current_user = request.env['current_user_id']
        tag = Tag.where(user_id:current_user).page(params[:page])
        render json:{resources:tag}
    end
end
