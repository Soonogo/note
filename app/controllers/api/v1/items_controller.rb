class Api::V1::ItemsController < ApplicationController
  def index
    user_id = request.env["current_user_id"]
    render status: :unauthorized if user_id.nil?
    item = Item.where({user_id:user_id}).where({created_at:params[:created_after]..params[:created_before]}).page params[:page]
    render json:{resource:item,pager:{
      page:params[:page]||1,
      per_page:Item.default_per_page,
      count:Item.count
    }}
  end
  def create
    item = Item.new amount: params[:amount]
    if item.save 
      render json:{resource:item}
    else
      render json:{errors:item.errors}
    end
  end
end
