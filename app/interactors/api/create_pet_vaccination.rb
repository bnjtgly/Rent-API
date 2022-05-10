module Api
  class CreatePetVaccination
    include Interactor

    delegate :data, :current_user, to: :context

    def call
      init
      validate!
      build
    end

    def rollback
      context.pet_vaccination&.destroy
    end

    private
    def init
      @pet = Pet.where(id: context.pet.id).first
    end

    def build
      @pet_vaccination = PetVaccination.new(payload)
      PetVaccination.transaction do
        @pet_vaccination.save
      end

      context.pet_vaccination = @pet_vaccination
    end

    def validate!
      verify = Api::CreatePetVaccinationValidator.new(payload)
      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        pet_id: @pet.id,
        pet_vaccine_type_id: data[:pet][:vaccination][:pet_vaccine_type_id],
        vaccination_date: data[:pet][:vaccination][:vaccination_date],
        proof: data[:pet][:vaccination][:proof]
      }
    end
  end
end
