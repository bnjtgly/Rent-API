require 'rails_helper'

RSpec.describe "Api::PetsControllers", type: :request do
  describe "GET /index" do
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
  end

  describe "POST /create" do
    context "creates pet" do
      before do
        user = authorize_user
        domain_type = create(:domain, name: 'Pet Type')
        domain_gender = create(:domain, name: 'Pet Gender')
        domain_weight = create(:domain, name: 'Pet Weight')

        pet_type = create(:domain_reference, domain: domain_type, role: %W[#{user.user_role.role.id}], display: 'Dog')
        pet_gender = create(:domain_reference, domain: domain_gender, role: %W[#{user.user_role.role.id}], display: Faker::Creature::Dog.gender)
        pet_weight = create(:domain_reference, domain: domain_weight, role: %W[#{user.user_role.role.id}], display: Faker::Number.between(from: 0.0, to: 5.0).ceil.to_s)

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

        ap params

        post '/api/pets', params: params, as: :json, headers: headers
      end

      it "returns http created" do
        expect(response.status).to eq(200)
      end

      it "returns json" do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

    end
  end
end
