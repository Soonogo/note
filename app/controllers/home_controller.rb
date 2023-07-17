class HomeController < ApplicationController
  def index
    render json:{message:"OK!"}
  end
end
