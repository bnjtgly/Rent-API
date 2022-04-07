require 'rails_helper'

RSpec.describe "Api::Properties", type: :request do
  describe "POST /create" do
    context "creates property" do
      before do
        authorize_user

        headers = { 'CONTENT_TYPE' => 'application/json' }
        params = {
          "property": {
            "details": {
              "id": Faker::Internet.uuid,
              "name": "#{Faker::Company.name} - #{Faker::Company.catch_phrase}",
              "address": Faker::Address.full_address,
              "bedrooms": Faker::Number.within(range: 1..5),
              "bathrooms": Faker::Number.within(range: 1..3),
              "garage": Faker::Number.within(range: 1..3),
              "availability": Faker::Date.between(from: '20152-01-01', to: '2022-12-31'),
              "rent_per_week": Faker::Number.between(from: 500.0, to: 5000.0).round(2)
            }
          }
        }

        post '/api/properties', params: params, as: :json, headers: headers
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

    context "unauthorized post" do
      before do
        post '/api/properties', params: {}, as: :json, headers: { 'CONTENT_TYPE' => 'application/json' }
      end

      it "returns http unauthorized" do
        expect(response.status).to eq(401)
      end
    end
  end
end
