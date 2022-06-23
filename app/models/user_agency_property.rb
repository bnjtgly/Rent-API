class UserAgencyProperty < ApplicationRecord
  belongs_to :user_agency
  belongs_to :property
end
