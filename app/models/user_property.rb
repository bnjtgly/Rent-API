class UserProperty < ApplicationRecord
  strip_attributes
  belongs_to :user
  belongs_to :property
end
