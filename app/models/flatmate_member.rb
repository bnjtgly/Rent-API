class FlatmateMember < ApplicationRecord
  strip_attributes
  belongs_to :flatmate
  belongs_to :user
end
