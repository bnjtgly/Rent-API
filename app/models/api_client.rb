class ApiClient < ApplicationRecord
  before_create :generate_api_key, :generate_secret_key
  before_save :titleize
  before_update :titleize

  protected
  def generate_secret_key
    self.secret_key = loop do
      random_key = SecureRandom.urlsafe_base64(nil, false)
      break random_key unless ApiClient.exists?(secret_key: random_key)
    end
  end

  def generate_api_key
    self.api_key = loop do
      random_api_key = SecureRandom.uuid
      break random_api_key unless ApiClient.exists?(api_key: random_api_key)
    end
  end

  def titleize
    self.name = name.try(:downcase).try(:titleize)
  end
end
