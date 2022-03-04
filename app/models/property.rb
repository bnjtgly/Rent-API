# frozen_string_literal: true

class Property < ApplicationRecord
  strip_attributes
  has_many :tenant_applications
  has_many :user_properties
end
