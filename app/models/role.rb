class Role < ApplicationRecord
  before_save :upcase
  before_update :upcase

  def upcase
    self.name = name.try(:upcase)
  end
end
