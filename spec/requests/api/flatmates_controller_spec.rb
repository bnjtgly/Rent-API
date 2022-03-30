require 'rails_helper'

RSpec.describe "Api::FlatmatesControllers", type: :request do
  describe "GET /index" do
    context "When user is logged in" do
      before do
        get_authorize_user

        get '/api/flatmates', as: :json
      end

      it "returns http success" do
        expect(response.status).to eq(200)
      end
    end

    context "When user is not logged in" do
      before do
        get '/api/flatmates', as: :json
      end

      it "returns http unauthorized" do
        expect(response.status).to eq(401)
      end
    end
  end
end
