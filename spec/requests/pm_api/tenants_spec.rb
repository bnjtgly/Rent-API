require 'rails_helper'

RSpec.describe "PmApi::Tenants", type: :request do
  describe "GET /index" do
    context "When PM is not logged in" do
      before do
        get '/pm_api/tenants', as: :json
      end

      it "returns http unauthorized" do
        expect(response.status).to eq(401)
      end
    end
  end
end
