require 'rails_helper'

RSpec.describe "Api::UserSettings", type: :request do
  describe "GET /api/user_settings" do
    context "When user is logged in" do
      let(:settings) { create(:domain, domain_number: 2701, name: 'User Settings') }

      before do
        user = authorize_user
        setting_2fa = create(:domain_reference, domain: settings, role: %W[#{user.user_role.role.id}], display: "Sms 2FA")
        setting_property_updates = create(:domain_reference, domain: settings, role: %W[#{user.user_role.role.id}], display: "Property Update")

        create(:user_setting, user_id: user.id, setting_id: setting_2fa.id, value: true)
        create(:user_setting, user_id: user.id, setting_id: setting_property_updates.id, value: true)

        get '/api/user_settings', as: :json
      end

      it "returns http success" do
        expect(response.status).to eq(200)
      end

      it "returns json" do
        hash_body = nil
        expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
        expect(hash_body[:data].first.keys).to match_array(%w[id user_id setting_id setting value])
      end
    end

    context "updates user_setting" do
      let(:user) { authorize_user }

      let(:settings) { create(:domain, domain_number: 2701, name: 'User Settings') }
      let(:setting_2fa) { create(:domain_reference, domain: settings, role: %W[#{user.user_role.role.id}], display: "Sms 2FA") }

      before do
        user_setting_2fa = create(:user_setting, user_id: user.id, setting_id: setting_2fa.id, value: true)
        headers = { 'CONTENT_TYPE' => 'application/json' }
        params = {
          "user_setting": {
            "value": Faker::Boolean.boolean
          }
        }

        patch "/api/user_settings/#{user_setting_2fa.id}", params: params, as: :json, headers: headers
      end

      it "returns http created" do
        expect(response.status).to eq(200)
      end

      it "returns json" do
        hash_body = nil
        expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
        expect(hash_body).to match({ message: 'Success' })
      end
    end
  end
end
