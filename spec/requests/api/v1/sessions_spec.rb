require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "post session" do
    it "create session" do
      User.create email:"tttsongen@foxmail.com"
      post "/api/v1/session",params:{email:"tttsongen@foxmail.com",code:"123456"}
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      expect(json["jwt"]).to be_a(String)
    end
  end
end
