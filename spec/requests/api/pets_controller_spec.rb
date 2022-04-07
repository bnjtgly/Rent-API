require 'rails_helper'

RSpec.describe "Api::PetsControllers", type: :request do
  describe "api/pets" do
    context "When user is logged in" do
      before do
        authorize_user

        get '/api/pets', as: :json
      end

      it "returns http success" do
        expect(response.status).to eq(200)
      end
    end

    context "When user is not logged in" do
      before do
        get '/api/pets', as: :json
      end

      it "returns http unauthorized" do
        expect(response.status).to eq(401)
      end
    end

    context "creates pet" do
      let(:user) { authorize_user }

      let(:domain_type) { create(:domain, domain_number: 1801, name: 'Pet Type') }
      let(:domain_gender) { create(:domain, domain_number: 1901, name: 'Pet Gender') }
      let(:domain_weight) { create(:domain, domain_number: 2001, name: 'Pet Weight') }

      let(:pet_type) { create(:domain_reference, domain: domain_type, role: %W[#{user.user_role.role.id}], display: 'Dog') }
      let(:pet_gender) { create(:domain_reference, domain: domain_gender, role: %W[#{user.user_role.role.id}], display: Faker::Creature::Dog.gender) }
      let(:pet_weight) { create(:domain_reference, domain: domain_weight, role: %W[#{user.user_role.role.id}], display: Faker::Number.between(from: 0.0, to: 5.0).ceil.to_s) }

      before do
        headers = { 'CONTENT_TYPE' => 'application/json' }
        params = {
          "pet": {
            "pet_type_id": pet_type.id,
            "pet_gender_id": pet_gender.id,
            "pet_weight_id": pet_weight.id,
            "name": Faker::Creature::Dog.name,
            "breed": Faker::Creature::Dog.breed,
            "color": Faker::Color.color_name
          }
        }

        post '/api/pets', params: params, as: :json, headers: headers
      end

      it "returns http created" do
        expect(response.status).to eq(200)
      end

      it "returns json" do
        hash_body = nil
        expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
        expect(hash_body[:data].keys).to match_array(%w[id user_id pet_type pet_gender pet_weight name breed color])
      end
    end

    context "unauthorized post" do
      before do
        post '/api/pets', params: {}, as: :json, headers: { 'CONTENT_TYPE' => 'application/json' }
      end

      it "returns http unauthorized" do
        expect(response.status).to eq(401)
      end
    end
  end
end
