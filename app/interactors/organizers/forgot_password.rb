class Organizers::ForgotPassword
  include Interactor::Organizer

  organize Forgot, SendOtp
end
