module Organizers
  class ForgotPassword
    include Interactor::Organizer

    organize Forgot, SendOtp
  end
end
