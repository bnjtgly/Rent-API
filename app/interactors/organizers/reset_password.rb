class Organizers::ResetPassword
  include Interactor::Organizer

  organize VerifyOtp, Reset, DestroyOtp
end
