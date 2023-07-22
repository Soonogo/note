class Api::V1::ItemsController < ApplicationController
  def index
    item = Item.where({created_at:params[:created_after]..params[:created_before]}).page params[:page]
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
