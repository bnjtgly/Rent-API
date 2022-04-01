require 'rails_helper'

RSpec.describe "Api::IdentitiesControllers", type: :request do
  describe "GET /index" do
    context "When user is logged in" do
      before do
        authorize_user

        get '/api/identities', as: :json
      end

      it "returns http success" do
        expect(response.status).to eq(200)
      end
    end

    context "When user is not logged in" do
      before do
        get '/api/identities', as: :json
      end

      it "returns http unauthorized" do
        expect(response.status).to eq(401)
      end
    end
  end

  # describe "POST /create" do
  #   context "creates identity" do
  #     before do
  #       role = create :role
  #       user = authorize_user(role)
  #       domain = create(:domain, name: 'Identity Type')
  #       identity_type_id = create(:domain_reference, domain: domain, role: %W[#{role.id}], display: 'Driver License', value_str: 'driver license')
  #
  #       ap domain
  #       ap identity_type_id
  #
  #       headers = { 'CONTENT_TYPE' => 'application/json' }
  #       params = {
  #         "current_user": user
  #         # "identity": {
  #         #   "identity_type_id": identity_type_id
  #         # }
  #       }
  #
  #       post '/api/identities', params: params, as: :json, headers: headers
  #     end
  #
  #     it "returns http created" do
  #       expect(response.status).to eq(201)
  #     end
      #
      # it "returns json" do
      #   expect(response.content_type).to eq("application/json")
      # end
  #   end
  # end
end
