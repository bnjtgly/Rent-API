class Domain < ApplicationRecord
  belongs_to :domain_control_level
  has_many :domain_references
  before_save :titleize
  before_update :titleize

  def titleize
    self.name = name.try(:downcase).try(:titleize)
  end
end
