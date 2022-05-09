# frozen_string_literal: true

json.id @property.id
json.applicants @property.tenant_applications.count
json.user_agency_id @property.user_agency_id
json.details @property.details
json.created_at @property.created_at
json.updated_at @property.updated_at
