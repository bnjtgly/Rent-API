require 'rails_helper'

RSpec.describe "Api::FlatmatesControllers", type: :request do
  describe "GET /index" do
    context "When user is logged in" do
      before do
        authorize_user

        get '/api/flatmates', as: :json
      end

      it "returns http success" do
        expect(response.status).to eq(200)
      end
    end

    context "When user is not logged in" do
      before do
        get '/api/flatmates', as: :json
      end

      it "returns http unauthorized" do
        expect(response.status).to eq(401)
      end
    end
  end

  describe "POST /create" do
    context "creates flatmate" do
      before do
        authorize_user

        headers = { 'CONTENT_TYPE' => 'application/json' }
        params = {
          "flatmate": {
            "group_name": Faker::Team.name
          }
        }

        post '/api/flatmates', params: params, as: :json, headers: headers
      end

      it "returns http created" do
        expect(response.status).to eq(200)
      end

      it "returns json" do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

    end
  end
end
