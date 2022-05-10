module Api
  module Organizers
    class SetupPet
      include Interactor::Organizer

      organize CreatePet, CreatePetVaccination
    end
  end
end
