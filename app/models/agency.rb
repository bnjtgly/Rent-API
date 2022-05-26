class Agency < ApplicationRecord
  strip_attributes
  has_many :properties, dependent: :destroy
end
