require 'rails_helper'

RSpec.describe User, type: :model do
  it "has email" do
    user = User.new email: "1@qq.com"
    expect(user.email).to eq("1@qq.com")
  end
end
