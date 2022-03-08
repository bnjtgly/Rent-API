class EmpDocument < ApplicationRecord
  strip_attributes
  belongs_to :employment
end
