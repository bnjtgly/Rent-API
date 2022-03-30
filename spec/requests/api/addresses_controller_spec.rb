require 'rails_helper'

RSpec.describe "Api::AddressesControllers", type: :request do
  describe "GET /index" do
    context "When user is logged in" do
      before do
        role = create :role
        authorize_user(role)
        get '/api/addresses', as: :json
      end

      it "returns http success" do
        expect(response.status).to eq(200)
      end
    end

    context "When user is not logged in" do
      before do
        get '/api/addresses', as: :json
      end

      it "returns http unauthorized" do
        expect(response.status).to eq(401)
      end
    end
  end

  # Quite complicated to implement with Organizer, we'll get back to it later.
  # describe "POST /create" do
  #   context "creates address" do
  #     before do
  #       user = authorize_user
  #       headers = { 'CONTENT_TYPE' => 'application/json' }
  #       params = {
  #         "current_user": user,
  #         "address": {
  #           "state": Faker::Address.street_name,
  #           "suburb": Faker::Address.street_name,
  #           "address": Faker::Address.street_address,
  #           "post_code": Faker::Address.postcode,
  #           "valid_from": Faker::Date.between(from: '2015-01-01', to: '2022-03-30'),
  #           "valid_thru": Faker::Date.between(from: '2018-01-01', to: '2022-03-30'),
  #           "reference": {
  #             "full_name": Faker::Name.name,
  #             "email": Faker::Internet.email,
  #             "ref_position_id": '4b4cb23e-b8d3-4b1c-9b3e-2d4d0978c205',
  #             "mobile_country_code_id": 'de5b5ab7-f01a-4816-ab2a-628915337eaa',
  #             "mobile": 9662262623
  #           }
  #         }
  #       }
  #       post '/api/addresses', params: params, as: :json, headers: headers
  #     end
  #
  #     it "returns http created" do
  #       expect(response.status).to eq(201)
  #     end
  #
  #     it "returns json" do
  #       expect(response.content_type).to eq("application/json")
  #     end
  #   end
  # end
end
