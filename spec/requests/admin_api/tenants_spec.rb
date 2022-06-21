require 'rails_helper'

RSpec.describe "AdminApi::Tenants", type: :request do
  describe "GET /index" do
    context "When PM is logged in" do
      before do
        authorize_admin

        get '/admin_api/tenants', as: :json
      end

      it "returns http success" do
        expect(response.status).to eq(200)
      end
    end

    context "When top applicant" do
      before do
        authorize_admin

        get '/admin_api/tenants/top_applicants', as: :json
      end

      it "returns http success" do
        expect(response.status).to eq(200)
      end

      it "returns json" do
        hash_body = nil
        expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
        expect(hash_body.keys).to match_array(%w[data pagy])
      end
    end

    context "When PM is not logged in" do
      before do
        get '/admin_api/tenants', as: :json
      end

      it "returns http unauthorized" do
        expect(response.status).to eq(401)
      end
    end
  end
end
