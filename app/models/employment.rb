class Employment < ApplicationRecord
  strip_attributes
  belongs_to :income
  has_many :emp_documents, dependent: :destroy
end
