require 'rails_helper'
require 'active_support/testing/time_helpers'

RSpec.describe "Mes", type: :request do
  include ActiveSupport::Testing::TimeHelpers
  describe "Get Me" do
    it "can get me" do
      user = User.create email:"tttsongen@foxmail.com"
      post "/api/v1/session",params:{email:"tttsongen@foxmail.com",code:"123456"}
      jwt = JSON.parse(response.body)["jwt"]
      get '/api/v1/me', headers: {'Authorization' => "Bearer #{jwt}"}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['resource']["id"]).to eq user.id
    end
    it "jwt过期" do
      travel_to Time.now - 3.hours
      user1 = User.create email: '1@qq.com'
      jwt = user1.generate_jwt

      travel_back
      get '/api/v1/me', headers: {'Authorization'=> "Bearer #{jwt}"}
      expect(response).to have_http_status(401)
    end
    it "jwt没过期" do
      travel_to Time.now - 1.hours
      user1 = User.create email: '1@qq.com'
      jwt = user1.generate_jwt

      travel_back
      get '/api/v1/me', headers: {'Authorization'=> "Bearer #{jwt}"}
      expect(response).to have_http_status(200)
    end
  end
end
