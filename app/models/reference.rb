# frozen_string_literal: true

class Reference < ApplicationRecord
  strip_attributes
  belongs_to :address, class_name: 'Address', foreign_key: 'address_id', optional: true
  belongs_to :employment, class_name: 'Employment', foreign_key: 'employment_id', optional: true

  # Domain References Association
  # List all domain_references columns in users table.
  belongs_to :ref_mobile_country_code, class_name: 'DomainReference', foreign_key: 'mobile_country_code_id', optional: true
  belongs_to :ref_ref_position, class_name: 'DomainReference', foreign_key: 'ref_position_id', optional: true

  def mobile_number
    "#{mobile_country_code_id.nil? ? '' : '+'}#{ref_mobile_country_code.value_str}#{mobile}"
  end
end
