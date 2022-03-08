class TenantApplicationHistory < ApplicationRecord
  strip_attributes
  belongs_to :tenant_application
end
