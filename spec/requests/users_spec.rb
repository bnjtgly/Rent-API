require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    context "When PM is not logged in" do
      before do
        get '/users/current', as: :json
      end

      it "returns http unauthorized" do
        expect(response.status).to eq(401)
      end
    end
  end
end
