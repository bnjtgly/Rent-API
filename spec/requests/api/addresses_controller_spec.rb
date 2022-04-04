require 'rails_helper'

RSpec.describe "Api::AddressesControllers", type: :request do
  describe "GET /index" do
    context "When user is logged in" do
      before do
        authorize_user

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

    context "creates address" do
      let(:user) { authorize_user }

      let(:reference_position) { create(:domain, domain_number: 2401, name: 'Address Reference Position') }
      let(:mobile_country_code) { create(:domain, domain_number: 1301, name: 'User Mobile Country Code') }

      let(:ref_position) { create(:domain_reference, domain: reference_position, role: %W[#{user.user_role.role.id}], display: 'Property Manager') }
      let(:mobile_country_code_ref) { create(:domain_reference, domain: mobile_country_code, role: %W[#{user.user_role.role.id}], display: '+61', value_str: '61') }

      before do
        headers = { 'CONTENT_TYPE' => 'application/json' }
        params = {
          "address": {
            "state": Faker::Address.state,
            "suburb": Faker::Address.city,
            "address": Faker::Address.street_address,
            "post_code": Faker::Number.number(digits: 5).to_s,
            "valid_from": Faker::Date.between(from: '2015-01-01', to: '2022-03-30'),
            "valid_thru": nil,
            "reference": {
              "full_name": "#{Faker::Name.first_name.gsub(/\W/, '').gsub("\u0000", '')} #{Faker::Name.last_name.gsub(/\W/, '').gsub("\u0000", '')}",
              "email": Faker::Internet.safe_email,
              "ref_position_id": ref_position.id,
              "mobile_country_code_id": mobile_country_code_ref.id,
              "mobile": "0491#{Faker::PhoneNumber.subscriber_number(length: 6)}"
            }
          }
        }

        post '/api/addresses', params: params, as: :json, headers: headers
      end

      it "returns http success" do
        expect(response.status).to eq(200)
      end

      it "returns json" do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "unauthorized post" do
      before do
        post '/api/addresses', params: {}, as: :json, headers: { 'CONTENT_TYPE' => 'application/json' }
      end

      it "returns http unauthorized" do
        expect(response.status).to eq(401)
      end
    end
  end
end
