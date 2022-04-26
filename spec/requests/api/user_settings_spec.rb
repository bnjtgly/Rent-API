require 'rails_helper'

RSpec.describe "Api::UserSettings", type: :request do
  describe "GET /api/user_settings" do
    context "When user is logged in" do
      let(:setting_2fa) { create(:setting, name: 'Sms 2FA', definition: 'Two-Factor Authentication') }
      let(:setting_property_updates) { create(:setting, name: 'Property Update', definition: 'Property Update') }

      before do
        user = authorize_user
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
  end
end
