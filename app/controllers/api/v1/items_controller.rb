class Api::V1::ItemsController < ApplicationController
  def index
    item = Item.page params[:page]
    render json:{resource:item,pager:{
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