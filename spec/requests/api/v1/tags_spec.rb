require 'rails_helper'

RSpec.describe "Tags", type: :request do
  describe "tags" do
    it "get tags" do
      user1 = User.create email:"tttsongen@foxmail.com"
      user2 = User.create email:"2@foxmail.com"

        11.times do |i| Tag.create name:"tag#{i}",sign:"x",user_id:user1.id end
        11.times do |i| Tag.create name:"tag#{i}",sign:"x",user_id:user2.id end
        get '/api/v1/tags',headers:user1.generate_jwt_header
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["resources"].length).to eq(10)
        get '/api/v1/tags',headers:user1.generate_jwt_header,params:{page:2}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["resources"].length).to eq(1)
    end
   
  end
end