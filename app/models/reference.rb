# frozen_string_literal: true

class Reference < ApplicationRecord
  strip_attributes
  belongs_to :address, optional: true
  belongs_to :employment, optional: true

  # Domain References Association
  # List all domain_references columns in users table.
  belongs_to :ref_mobile_country_code, class_name: 'DomainReference', foreign_key: 'mobile_country_code_id', optional: true
  belongs_to :ref_ref_position, class_name: 'DomainReference', foreign_key: 'ref_position_id', optional: true
end
