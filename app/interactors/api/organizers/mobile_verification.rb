class Api::Organizers::MobileVerification
  include Interactor::Organizer

  organize VerifyOtp, UpdateIsMobileVerified, DestroyOtp
end
