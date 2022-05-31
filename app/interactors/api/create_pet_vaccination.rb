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
      payload[:vaccination_attributes].each do |value|
        @pet_vaccination = PetVaccination.new(
          {
            pet_id: @pet.id,
            pet_vaccine_type_id: value[:pet_vaccine_type_id],
            vaccination_date: value[:vaccination_date],
            proof: value[:proof]
          })

        PetVaccination.transaction do
          @pet_vaccination.save
        end
      end

      context.pet_vaccination = @pet.pet_vaccinations
    end

    def validate!
      verify = Api::CreatePetVaccinationValidator.new(payload)
      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        pet_id: @pet.id,
        vaccination_attributes: data[:pet][:vaccination]
      }
    end
  end
end
