require 'rails_helper'

RSpec.describe "Api::IncomesControllers", type: :request do
  describe "api/incomes" do
    context "When user is logged in" do
      before do
        authorize_user

        get '/api/incomes', as: :json
      end

      it "returns http success" do
        expect(response.status).to eq(200)
      end
    end

    context "When user is not logged in" do
      before do
        get '/api/incomes', as: :json
      end

      it "returns http unauthorized" do
        expect(response.status).to eq(401)
      end
    end

    context "creates income" do
      let(:user) { authorize_user }

      let(:income_freq) { create(:domain, domain_number: 1701, name: 'Income Frequency') }
      let(:income_src) { create(:domain, domain_number: 1601, name: 'Income Source') }
      let(:currency) { create(:domain, domain_number: 2501, name: 'Currency') }

      let(:income_source) { create(:domain_reference, domain: income_src, role: %W[#{user.user_role.role.id}], display: 'Allowance') }
      let(:income_frequency) { create(:domain_reference, domain: income_freq, role: %W[#{user.user_role.role.id}], display: 'Monthly') }
      let(:currency_id) { create(:domain_reference, domain: currency, role: %W[#{user.user_role.role.id}], display: 'A$', value_str: 'AUD') }

      before do
        headers = { 'CONTENT_TYPE' => 'application/json' }
        params = {
          "income": {
            "income_source_id": income_source.id,
            "income_frequency_id": income_frequency.id,
            "currency_id": currency_id.id,
            "amount": Faker::Number.number(digits: 5)
          }
        }

        post '/api/incomes', params: params, as: :json, headers: headers
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
        post '/api/incomes', params: {}, as: :json, headers: { 'CONTENT_TYPE' => 'application/json' }
      end

      it "returns http unauthorized" do
        expect(response.status).to eq(401)
      end
    end
  end
end
