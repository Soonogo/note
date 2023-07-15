class UsersController < ApplicationController
  def create
    p "create"
    user = User.new email: "123@qq.com", name: "123"
    if user.save
      p 'success'
      render json: user
      else
      p 'fail'
      render json: user.errors
    end
  end

  def show
    user = User.find_by_id params[:id]
    render json: user
  end
end
