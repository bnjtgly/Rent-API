# frozen_string_literal: true

class Flatmate < ApplicationRecord
  strip_attributes
  belongs_to :user
  has_many :flatmate_members, dependent: :destroy
  audited associated_with: :user
end
