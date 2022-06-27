# frozen_string_literal: true

json.id @identity.id
json.user_id @identity.user_id
json.identity_type @identity.ref_identity_type.display
json.id_number @identity.id_number
json.file @identity.file