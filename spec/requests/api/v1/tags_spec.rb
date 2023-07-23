require 'rails_helper'

RSpec.describe "Tags", type: :request do
  describe "tags" do
    it "not sign_in" do
      get '/api/v1/tags'
      expect(response).to have_http_status(401)
    end
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
    it "post tags" do
      user1 = User.create email:"tttsongen@foxmail.com"
        post '/api/v1/tags',headers:user1.generate_jwt_header,params:{sign:"sign",name:"name"}
        expect(response).to have_http_status(200)
        json = JSON.parse response.body
        expect(json["resource"]["sign"]).to eq("sign")
        expect(json["resource"]["name"]).to eq("name")
    end
    it "post tags no sign field" do
      user1 = User.create email:"tttsongen@foxmail.com"
        post '/api/v1/tags',headers:user1.generate_jwt_header,params:{name:"name"}
        expect(response).to have_http_status(422)
        json = JSON.parse response.body
        expect(json["errors"]["sign"][0]).to eq("can't be blank")
    end
  end
  describe "update" do
    it "not sign_in" do
      patch '/api/v1/tags'
      expect(response).to have_http_status(401)
    end
    it "update tags field" do
      user1 = User.create email:"tttsongen@foxmail.com"
      tag = Tag.create name:"tag",sign:"x",user_id:user1.id
        patch "/api/v1/tags/#{tag.id}",headers:user1.generate_jwt_header,params:{sign:"s",name:"n"}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["resource"]["sign"]).to eq("s")
        expect(JSON.parse(response.body)["resource"]["name"]).to eq("n")
    end
    it "update tags field" do
      user1 = User.create email:"tttsongen@foxmail.com"
      tag = Tag.create name:"tag",sign:"x",user_id:user1.id
        patch "/api/v1/tags/#{tag.id}",headers:user1.generate_jwt_header,params:{sign:"s"}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["resource"]["sign"]).to eq("s")
        expect(JSON.parse(response.body)["resource"]["name"]).to eq("tag")
    end
  end
  describe "delete" do
    it "not sign_in" do
      delete '/api/v1/tags'
      expect(response).to have_http_status(401)
    end
    it "delete tags" do
      user1 = User.create email:"tttsongen@foxmail.com"
      tag = Tag.create name:"tag",sign:"x",user_id:user1.id
        delete "/api/v1/tags/#{tag.id}",headers:user1.generate_jwt_header
        expect(response).to have_http_status(200)
    end
    it "delete other user tags" do
      user1 = User.create email:"1@foxmail.com"
      user2 = User.create email:"2@foxmail.com"
      tag = Tag.create name:"tag",sign:"x",user_id:user2.id
        delete "/api/v1/tags/#{tag.id}",headers:user1.generate_jwt_header
        expect(response).to have_http_status(403)
    end
    
  end
end