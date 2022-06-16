class Agency < ApplicationRecord
  strip_attributes
  has_many :properties, dependent: :destroy

  belongs_to :ref_mobile_country_code, class_name: 'DomainReference', foreign_key: 'mobile_country_code_id', optional: true
end
