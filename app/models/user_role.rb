# frozen_string_literal: true

class UserRole < ApplicationRecord
  strip_attributes
  belongs_to :user
  belongs_to :role

  audited associated_with: :user
end
