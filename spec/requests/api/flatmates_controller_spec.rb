require 'rails_helper'

RSpec.describe "Api::FlatmatesControllers", type: :request do
  describe "api/flatmates" do
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
        hash_body = nil
        expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
        expect(hash_body[:data].keys).to match_array(%w[id group_name flatmates_progress])
      end
    end

    context "unauthorized post" do
      before do
        post '/api/flatmates', params: {}, as: :json, headers: { 'CONTENT_TYPE' => 'application/json' }
      end

      it "returns http unauthorized" do
        expect(response.status).to eq(401)
      end
    end
  end
end
