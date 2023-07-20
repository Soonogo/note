require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Validation Codes" do
  post "/api/v1/validation_codes" do
    parameter :email,type: :string,required:true
    let(:email){'1@qq.com'}
    header "Content-Type", "application/json"
    example "Listing items" do
      do_request
      expect(status).to eq 200
    end
  end
end