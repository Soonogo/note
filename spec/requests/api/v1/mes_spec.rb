require 'rails_helper'

RSpec.describe "Mes", type: :request do
  describe "Get Me" do
    it "can get me" do
      user = User.create email:"tttsongen@foxmail.com"
      post "/api/v1/session",params:{email:"tttsongen@foxmail.com",code:"123456"}
      # add header
      jwt = JSON.parse(response.body)["jwt"]
      # get me add header
      get '/api/v1/me', headers: {'Authorization' => "Bearer #{jwt}"}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['resource']["id"]).to eq user.id
    end
  end
end
