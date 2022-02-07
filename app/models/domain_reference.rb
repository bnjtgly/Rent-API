class DomainReference < ApplicationRecord
  belongs_to :domain
  belongs_to :domain_control_level
end
