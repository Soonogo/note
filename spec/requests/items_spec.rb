require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "GET /items" do
    it "works! (now write some real specs)" do
      11.times do |i|
        Item.create amount:10
      end
      expect(Item.count).to eq(11)
      get "/api/v1/items"
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["resource"].length).to eq 10
    end
  end
  describe "create" do
    it "can create item" do
      expect { post "/api/v1/items",params:{amount:12}}.to change { Item.count }.by(1)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["resource"]["id"]).to be_an(Numeric)
      expect(JSON.parse(response.body)["resource"]["amount"]).to eq 12
    end
  end
end
