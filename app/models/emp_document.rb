class EmpDocument < ApplicationRecord
  strip_attributes
  mount_base64_uploader :filename, EmploymentUploader

  belongs_to :employment
end
