require 'rails_helper'

RSpec.describe "PasswordsControllers", type: :request do
  describe "/password/update_password" do
    def alphanumeric_password
      specials = ((35..38).to_a + (91..96).to_a).pack('U*').chars.to_a
      characters = specials
      password = Random.new.rand(1..2).times.map{characters.sample}
      password << Faker::Internet.password(min_length: 15, mix_case: true)
      password.shuffle.join
    end

    context "updates password" do
      let(:user) { authorize_user }
      let(:password) { alphanumeric_password }

      before do
        headers = { 'CONTENT_TYPE' => 'application/json' }
        params = {
          "password": {
            "current_password": user.password,
            "password": password,
            "password_confirmation": password,
          }
        }

        post '/password/update_password', params: params, as: :json, headers: headers
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
