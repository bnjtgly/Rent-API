# frozen_string_literal: true

class Address < ApplicationRecord
  strip_attributes
  belongs_to :user
  has_one :reference, dependent: :destroy

  audited associated_with: :user
end
