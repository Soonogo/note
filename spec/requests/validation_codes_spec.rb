require 'rails_helper'

RSpec.describe "ValidationCodes", type: :request do
  describe "post validation_codes" do
    it "can be send" do
      post "/api/v1/validation_codes",params:{email:"tttsongen@foxmail.com"}
      expect(response).to have_http_status(200)
      post "/api/v1/validation_codes",params:{email:"tttsongen@foxmail.com"}
      expect(response).to have_http_status(429)
    end
  end
end
