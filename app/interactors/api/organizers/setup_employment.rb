module Api
  module Organizers
    class SetupEmployment
      include Interactor::Organizer

      organize CreateEmployment, CreateEmpDocument
    end
  end
end
