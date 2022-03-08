# frozen_string_literal: true

class Income < ApplicationRecord
  strip_attributes
  belongs_to :user
  has_one :employment, dependent: :destroy

  # Domain References Association
  # List all domain_references columns in users table.
  belongs_to :ref_income_source, class_name: 'DomainReference', foreign_key: 'income_source_id', optional: true
  belongs_to :ref_income_frequency, class_name: 'DomainReference', foreign_key: 'income_frequency_id', optional: true
end
