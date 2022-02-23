module Organizers
  class ResetPassword
    include Interactor::Organizer

    organize VerifyOtp, Reset, DestroyOtp
  end
end