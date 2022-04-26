class UserSetting < ApplicationRecord
  strip_attributes
  belongs_to :user
  belongs_to :setting

  audited associated_with: :user
end
