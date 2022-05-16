require 'rails_helper'

RSpec.describe "PmApi::Properties", type: :request do
  describe "GET /index" do
    context "When PM is logged in" do
      before do
        authorize_pm

        get '/pm_api/properties', as: :json
      end

      it "returns http success" do
        expect(response.status).to eq(200)
      end
    end

    context "When PM is not logged in" do
      before do
        get '/pm_api/properties', as: :json
      end

      it "returns http unauthorized" do
        expect(response.status).to eq(401)
      end
    end
  end

  describe "POST /create" do
    context "creates flatmate" do
      before do
        authorize_pm

        params = {
          "property": {
            "details": {
              "id": "4282f033-689f-41c1-a874-939a2f9e8a58",
              "name": "Treehouse hosted by Mikheyla Fox 1",
              "address": "Sixth Avenue, New Norfolk TAS, Australia",
              "bedrooms": "4",
              "bathrooms": "3",
              "garage": "2",
              "availability": "2022-05-22",
              "rent_per_week": "1100"
            }
          }
        }

        post '/pm_api/properties', params: params, as: :json
      end

      it "returns http created" do
        expect(response.status).to eq(200)
      end

      it "returns json" do
        hash_body = nil
        expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
        expect(hash_body[:data].keys).to match_array(%w[id details])
      end
    end
  end
end
