class UserAgency < ApplicationRecord
  strip_attributes
  belongs_to :user
  belongs_to :agency
  has_many :user_agency_properties

  audited associated_with: :user
end