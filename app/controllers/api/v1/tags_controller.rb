class Api::V1::TagsController < ApplicationController
    def index
        current_user = User.find_by_id request.env['current_user_id']
        return render status: :unauthorized if current_user.nil?
        tag = Tag.where(user_id:current_user.id).page(params[:page])
        render json:{resources:tag,pager:{
            page:params[:page]||1,
            per_page:Tag.default_per_page,
            count:Tag.where(user_id:current_user.id).count
          }}
    end
    def create
        current_user = User.find_by_id request.env['current_user_id']
        return render status: :unauthorized if current_user.nil?
        tag = Tag.new name:params[:name],sign:params[:sign],user_id:current_user.id
        if tag.save
            render json:{resource:tag},status:200
        else
            render json:{errors:tag.errors},status:422
        end
    end
    def update
        tag = Tag.find params[:id]
        tag.update params.permit(:name,:sign)
        if tag.errors.empty?
            render json:{resource:tag},status:200
        else
            render json:{errors:tag.errors},status:422
        end
    end
    def destroy
        tag = Tag.find params[:id]
        return head :forbidden unless tag.user_id === request.env['current_user_id']
        tag.deleted_at = Time.now
        if tag.save
            render status:200
        else
            render json:{errors:tag.errors},status:422
        end
    end
end
