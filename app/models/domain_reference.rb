class DomainReference < ApplicationRecord
  belongs_to :domain
  belongs_to :control_level
end
