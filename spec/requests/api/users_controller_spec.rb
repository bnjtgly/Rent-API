require 'rails_helper'

RSpec.describe "Api::UsersControllers", type: :request do
  describe "/api/users/update_account" do
    context "updates account" do
      let(:user) { authorize_user }

      before do
        headers = { 'CONTENT_TYPE' => 'application/json' }
        params = {
          "user": {
            "email": user.email,
            "first_name": Faker::Name.first_name.gsub(/\W/, '').gsub("\u0000", ''),
            "last_name": Faker::Name.last_name.gsub(/\W/, '').gsub("\u0000", ''),
          }
        }

        post '/api/users/update_account', params: params, as: :json, headers: headers
      end

      it "returns http created" do
        expect(response.status).to eq(200)
      end

      it "returns json success" do
        hash_body = nil
        expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
        expect(hash_body).to match({ message: 'Success' })
      end
    end
  end
end
