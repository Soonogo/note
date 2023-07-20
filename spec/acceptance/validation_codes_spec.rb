require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Validation Codes" do
  post "/api/v1/validation_codes" do
    parameter :email,type: :string,required:true
    let(:email){'1@qq.com'}
    example "Listing items" do
      expect(UserMailer).to receive(:welcome_email).with(email)
      do_request
      expect(response_body).to eq ' '
      do_request
      expect(status).to eq 429

    end
  end
end