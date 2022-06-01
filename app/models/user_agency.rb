class UserAgency < ApplicationRecord
  strip_attributes
  belongs_to :user
  belongs_to :agency

  audited associated_with: :user
end