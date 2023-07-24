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
    item = Item.new params.permit(:amount,:happen_at,tags_id:[])
    item.user_id = request.env['current_user_id']
    if item.save 
      render json:{resource:item}
    else
      render json:{errors:item.errors},status: :unprocessable_entity
    end
  end
  def summary
    hash = Hash.new
    items = Item
      .where(user_id: request.env['current_user_id'])
      .where(kind: params[:kind])
      .where(happen_at: params[:happened_after]..params[:happened_before])
    items.each do |item|
      key = item.happen_at.in_time_zone('Beijing').strftime('%F')
      hash[key] ||= 0
      hash[key] += item.amount
    end
    groups = hash
      .map { |key, value| {"happen_at": key, amount: value} }
      .sort { |a, b| a[:happen_at] <=> b[:happen_at] }
    render json: {
      groups: groups,
      total: items.sum(:amount)
    }
  end
end
