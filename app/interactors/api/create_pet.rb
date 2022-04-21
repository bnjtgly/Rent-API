module Api
  class CreatePet
    include Interactor

    delegate :data, :current_user, to: :context

    def call
      validate!
      build
    end

    def rollback
      context.pet&.destroy
    end

    private

    def build
      @pet = Pet.new(payload)
      Pet.transaction do
        @pet.save
      end

      context.pet = @pet
    end

    def validate!
      verify = Api::CreatePetValidator.new(payload)
      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        audit_comment: 'Create Pet',
        user_id: current_user.id,
        pet_type_id: data[:pet][:pet_type_id],
        pet_gender_id: data[:pet][:pet_gender_id],
        pet_weight_id: data[:pet][:pet_weight_id],
        pet_vaccine_type_id: data[:pet][:pet_vaccine_type_id],
        name: data[:pet][:name],
        breed: data[:pet][:breed],
        color: data[:pet][:color],
        vaccination_date: data[:pet][:vaccination_date],
        proof: data[:pet][:proof]
      }
    end
  end
end





