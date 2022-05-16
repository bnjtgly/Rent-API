require 'rails_helper'

RSpec.describe "PmApi::TenantApplications", type: :request do
  describe "GET /index" do
    context "When PM is logged in" do
      before do
        authorize_pm

        get '/pm_api/tenant_applications', as: :json
      end

      it "returns http success" do
        expect(response.status).to eq(200)
      end
    end

    context "When PM is not logged in" do
      before do
        get '/pm_api/tenant_applications', as: :json
      end

      it "returns http unauthorized" do
        expect(response.status).to eq(401)
      end
    end
  end
end
