# frozen_string_literal: true

class Flatmate < ApplicationRecord
  strip_attributes
  belongs_to :user
end
