class DomainReference < ApplicationRecord
  strip_attributes
  belongs_to :domain
end
