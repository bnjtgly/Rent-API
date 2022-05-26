# frozen_string_literal: true

class Property < ApplicationRecord
  strip_attributes
  has_many :tenant_applications, dependent: :destroy
  has_many :user_properties, dependent: :destroy
  belongs_to :agency
end
