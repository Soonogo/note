class Api::V1::ValidationCodesController < ApplicationController
  def create
    code = SecureRandom.random_number.to_s[2..7]
    validation_code = ValidationCode.new code: code,email:params[:email],kind:"sign_in"
    if validation_code.save
      render json: {code:code},status:200
    else
      render json:{errors:validation_code.errors},status:400
    end
  end
end
