module Api
  module Organizers
    class MobileVerification
      include Interactor::Organizer

      # organize VerifyOtp, UpdateIsMobileVerified, DestroyOtp
      organize VerifyOtp
    end
  end
end
