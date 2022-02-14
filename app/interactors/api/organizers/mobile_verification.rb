module Api
  module Organizers
    class MobileVerification
      include Interactor::Organizer

      organize VerifyOtp, UpdateIsMobileVerified, DestroyOtp
    end
  end
end
