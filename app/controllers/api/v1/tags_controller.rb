class Api::V1::TagsController < ApplicationController
    def index
        user_id = request.env['current_user_id']
        tag = Tag.where(user_id:user_id).page(params[:page])
        render json:{resources:tag,pager:{
            page:params[:page]||1,
            per_page:Tag.default_per_page,
            count:Tag.where(user_id:user_id).count
          }}
    end
end
