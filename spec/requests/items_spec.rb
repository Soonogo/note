require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "GET /items" do
    it "works! (now write some real specs)" do
      User1 = User.create email:"1@qq.com"
      11.times do |i|
        Item.create amount:10,user_id:User1.id
      end
      expect(Item.count).to eq(11)
      get "/api/v1/items",headers:  User1.generate_jwt_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["resource"].length).to eq 10
    end
    it "can filter items(not sing_in)" do
      User1 = User.create email:"1@qq.com"
      User2 = User.create email:"2@qq.com"
      11.times do
      Item1 = Item.create amount:100,created_at:Time.new(2019,1,2),user_id:User1.id
      Item2 = Item.create amount:100,created_at:Time.new(2020,1,1),user_id:User2.id
      end
      get "/api/v1/items",headers:  User1.generate_jwt_header
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["resource"].length).to eq 10
      get "/api/v1/items?page=2",headers:  User1.generate_jwt_header
      expect(JSON.parse(response.body)["resource"].length).to eq 1
    end
    it "can filter items" do
      User1 = User.create email:"1@qq.com"
      Item1 = Item.create amount:100,created_at:Time.new(2019,1,2),user_id:User1.id
      Item2 = Item.create amount:100,created_at:Time.new(2020,1,1),user_id:User1.id
      get "/api/v1/items?created_after=2019-01-01&created_before=2019-01-03",headers:  User1.generate_jwt_header
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["resource"].length).to eq 1
      expect(JSON.parse(response.body)["resource"][0]["id"]).to eq Item1.id
    end
    it "can filter items2" do
      User1 = User.create email:"1@qq.com"
      Item1 = Item.create amount:100,created_at:Time.new(2019,1,2),user_id:User1.id
      Item2 = Item.create amount:100,created_at:Time.new(2020,1,1),user_id:User1.id
      get "/api/v1/items?created_after=2019-01-02",headers: User1.generate_jwt_header
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["resource"].length).to eq 1
      expect(JSON.parse(response.body)["resource"][0]["id"]).to eq Item2.id
    end
    it "can filter items3" do
      User1 = User.create email:"1@qq.com"
      Item1 = Item.create amount:100,created_at:Time.new(2019,1,2),user_id:User1.id
      Item2 = Item.create amount:100,created_at:Time.new(2020,1,1),user_id:User1.id
     
      get "/api/v1/items?created_before=2019-01-03",headers: User1.generate_jwt_header
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["resource"].length).to eq 1
      expect(JSON.parse(response.body)["resource"][0]["id"]).to eq Item1.id
    end
    it "can filter items(Time zone boundary)" do
      User1 = User.create email:"1@qq.com"

      Item1 = Item.create amount:100,created_at:Time.new(2019,1,1,0,0,0,"+00:00"),user_id:User1.id
      Item2 = Item.create amount:100,created_at:Time.new(2020,1,1),user_id:User1.id
      get "/api/v1/items?created_after=2019-01-01&created_before=2019-01-03",headers:  User1.generate_jwt_header
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["resource"].length).to eq 1
      expect(JSON.parse(response.body)["resource"][0]["id"]).to eq Item1.id
    end
  end
  describe "create" do
    xit "can create item" do
      expect { post "/api/v1/items",params:{amount:12}}.to change { Item.count }.by(1)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["resource"]["id"]).to be_an(Numeric)
      expect(JSON.parse(response.body)["resource"]["amount"]).to eq 12
    end
  end
end
