class Role < ApplicationRecord
  strip_attributes
  before_save :upcase
  before_update :upcase

  def upcase
    self.role_name = role_name.try(:upcase)
  end
end
