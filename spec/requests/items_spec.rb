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
    it "not sign_in" do
      post "/api/v1/items",params:{amount:12}
      expect(response).to have_http_status(401)
    end
    it "can create item" do
      user = User.create email:"1@qq.com"
      tag1 = Tag.create name:"tag1",user_id:user.id,sign:"x"
      tag2 = Tag.create name:"tag2",user_id:user.id,sign:"x"
      expect { post "/api/v1/items",params:{amount:12,tags_id:[tag1.id,tag2.id],happen_at:'2018-01-01T00:00:00+08:00'},headers:user.generate_jwt_header}.to change { Item.count }.by(1)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["resource"]["id"]).to be_an(Numeric)
      expect(JSON.parse(response.body)["resource"]["amount"]).to eq 12
      expect(JSON.parse(response.body)["resource"]["user_id"]).to eq user.id
      expect(JSON.parse(response.body)["resource"]["happen_at"]).to eq '2017-12-31T16:00:00.000Z'
    end
    it "Required field amount/tags_id/happen_at" do
      user = User.create email:"1@qq.com"
      post "/api/v1/items",params:{},headers:user.generate_jwt_header
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["errors"]["tags_id"][0]).to eq "can't be blank"
      expect(JSON.parse(response.body)["errors"]["amount"][0]).to eq "can't be blank"
      expect(JSON.parse(response.body)["errors"]["happen_at"][0]).to eq "can't be blank"
    end
  end
  describe "统计数据" do 
    it '按天分组' do
      user = User.create! email: '1@qq.com'
      tag = Tag.create! name: 'tag1', sign: 'x', user_id: user.id
      Item.create! amount: 100, kind: 'expenses', tags_id: [tag.id], happen_at: '2018-06-18T00:00:00+08:00', user_id: user.id
      Item.create! amount: 200, kind: 'expenses', tags_id: [tag.id], happen_at: '2018-06-18T00:00:00+08:00', user_id: user.id
      Item.create! amount: 100, kind: 'expenses', tags_id: [tag.id], happen_at: '2018-06-20T00:00:00+08:00', user_id: user.id
      Item.create! amount: 200, kind: 'expenses', tags_id: [tag.id], happen_at: '2018-06-20T00:00:00+08:00', user_id: user.id
      Item.create! amount: 100, kind: 'expenses', tags_id: [tag.id], happen_at: '2018-06-19T00:00:00+08:00', user_id: user.id
      Item.create! amount: 200, kind: 'expenses', tags_id: [tag.id], happen_at: '2018-06-19T00:00:00+08:00', user_id: user.id
      get '/api/v1/items/summary', params: {
        happened_after: '2018-01-01',
        happened_before: '2019-01-01',
        kind: 'expenses',
        group_by: 'happen_at'
      }, headers: user.generate_jwt_header
      expect(response).to have_http_status 200
      json = JSON.parse response.body
      expect(json['groups'].size).to eq 3
      expect(json['groups'][0]['happen_at']).to eq '2018-06-18'
      expect(json['groups'][0]['amount']).to eq 300
      expect(json['groups'][1]['happen_at']).to eq '2018-06-19'
      expect(json['groups'][1]['amount']).to eq 300
      expect(json['groups'][2]['happen_at']).to eq '2018-06-20'
      expect(json['groups'][2]['amount']).to eq 300
      expect(json['total']).to eq 900
    end
  end
end
