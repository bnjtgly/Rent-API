module Api
  module Organizers
    class SetupAddress
      include Interactor::Organizer

      organize CreateAddress, CreateReference
    end
  end
end
