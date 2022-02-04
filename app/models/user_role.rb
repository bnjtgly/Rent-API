class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role

  audited associated_with: :user
end
