class UserAgency < ApplicationRecord
  strip_attributes
  # belongs_to :user
  belongs_to :host, class_name: 'User', foreign_key: 'host_id', optional: true
  belongs_to :agency
end