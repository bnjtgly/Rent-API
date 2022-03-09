# frozen_string_literal: true

class Pet < ApplicationRecord
  strip_attributes
  belongs_to :user

  # Domain References Association
  # List all domain_references columns in users table.
  belongs_to :ref_pet_type, class_name: 'DomainReference', foreign_key: 'pet_type_id', optional: true
  belongs_to :ref_pet_gender, class_name: 'DomainReference', foreign_key: 'pet_gender_id', optional: true
  belongs_to :ref_pet_weight, class_name: 'DomainReference', foreign_key: 'pet_weight_id', optional: true

  audited associated_with: :user
end
