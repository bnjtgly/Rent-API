class EmpDocument < ApplicationRecord
  strip_attributes
  mount_base64_uploader :file, EmploymentUploader

  belongs_to :employment
end
