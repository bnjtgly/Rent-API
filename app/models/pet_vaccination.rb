class PetVaccination < ApplicationRecord
  strip_attributes
  mount_base64_uploader :proof, PetVaccinationUploader

  belongs_to :pet

  # Domain References Association
  # List all domain_references columns in users table.
  belongs_to :ref_pet_vaccine_type, class_name: 'DomainReference', foreign_key: 'pet_vaccine_type_id', optional: true
end
