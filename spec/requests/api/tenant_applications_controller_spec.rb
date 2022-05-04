require 'rails_helper'

RSpec.describe "Api::TenantApplicationsControllers", type: :request do
  describe "/api/tenant_applications" do
    context "When user is logged in" do
      before do
        authorize_user

        get '/api/tenant_applications', as: :json
      end

      it "returns http success" do
        expect(response.status).to eq(200)
      end
    end

    context "When user is not logged in" do
      before do
        get '/api/tenant_applications', as: :json
      end

      it "returns http unauthorized" do
        expect(response.status).to eq(401)
      end
    end

    context "creates tenant application" do
      let(:user) { authorize_user }
      let(:agency) { create :agency }
      let(:user_agency) { create(agency: agency, host: user) }
      let(:property) { create :property }
      let(:flatmate) { create :flatmate }

      let(:lease) { create(:domain, domain_number: 2601, name: 'Lease Length') }
      let(:lease_length) { create(:domain_reference, domain: lease, role: %W[#{user.user_role.role.id}], display: "24 Months", value_str: '24') }

      before do
        headers = { 'CONTENT_TYPE' => 'application/json' }
        params = {
          "tenant_application": {
            "property_id": property.id,
            "flatmate_id": flatmate.id,
            "lease_length_id": lease_length.id,
            "lease_start_date": Faker::Date.between(from: '2022-01-01', to: '2022-12-31')
          }
        }

        post '/api/tenant_applications', params: params, as: :json, headers: headers
      end

      it "returns http created" do
        expect(response.status).to eq(200)
      end

      it "returns json" do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "unauthorized post" do
      before do
        post '/api/tenant_applications', params: {}, as: :json, headers: { 'CONTENT_TYPE' => 'application/json' }
      end

      it "returns http unauthorized" do
        expect(response.status).to eq(401)
      end
    end
  end
end
