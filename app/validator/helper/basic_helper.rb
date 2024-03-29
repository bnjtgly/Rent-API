require 'uri'

module Helper
  module BasicHelper
    PLEASE_CHANGE_MESSAGE = 'Please Change.'
    NOT_FOUND = 'Record does not exist.'
    REQUIRED_MESSAGE = 'This field is required.'
    PASSWORD_REQUIREMENTS_MESSAGE = 'Password should have more than 6 characters including 1 lower letter, 1 uppercase letter, 1 number and 1 symbol.'
    EMAIL_EXIST_MESSAGE = 'Email already exist.'
    ENGLISH_ALPHABETS_ONLY_MESSAGE = 'Only english alphabets are allowed (letters only).'
    NO_SPACE_ALLOWED = 'No spaces allowed.'
    NAME_EXIST_MESSAGE = 'Name already exist.'
    VALID_NUMBER_MESSAGE = 'Please enter valid number.'
    VALID_PHONE_MESSAGE = 'Please enter a valid phone number.'
    VALID_MOBILE_MESSAGE = 'Please enter a valid mobile number.'
    VALID_DATE_MESSAGE = 'Please enter valid date. Date must be YYYY-MM-DD.'
    VALID_BOOLEAN_MESSAGE = 'Please enter a valid value. Must be true or false'
    VALID_BASE64_MESSAGE = 'Please enter a valid base64.'
    VALID_IMG_TYPE_MESSAGE = 'Please enter a valid image type.'
    VALID_IDENTITY_PROOF_MESSAGE = 'Please enter a valid file type.'
    VALID_IMG_SIZE_MESSAGE = 'Attachment size exceeds the allowable limit (5 MB).'
    VALID_AMOUNT = 'Please enter a valid amount.'
    VALID_COMPANY_NAME_MESSAGE = "Not allowed multiple spaces between words. Accepted values are alpha numeric and ['&:.,@-] special characters only."
    VALID_JSON_MESSAGE = "Please enter a valid value. Must be json."
    USER_ID_NOT_FOUND = 'We do not recognize your Account. Please try again.'
    MOBILE_NOT_VERIFIED = 'Your mobile number is not verified. Please verify your mobile number first.'
    EMAIL_NOT_VERIFIED = 'Your email address is not verified. Please verify your email address first.'
    TABLE_NOT_EXIST_MESSAGE = 'Table does not exist.'
    COLUMN_NOT_EXIST_MESSAGE = 'Column does not exist.'
    RECORD_EXIST_MESSAGE = 'Record already exist.'
    ID_EXIST_MESSAGE = 'This ID number is already in use by another user.'
    ID_TYPE_EXISTS = 'ID type already exists.'
    INCORRECT_PASSWORD = 'Incorrect Password.'
    INVALID_URL = 'Invalid URL.'
    INVALID_ACCESS = 'You do no have access to modify this record.'
    VALID_AFFORDABILITY = 'Your total income is lower than the require 30%.'

    DOMAIN_STATUSES = ['Active', 'Coming Soon', 'Disabled'].freeze

    def valid_float?(value)
      data = Float(value.to_s, exception: false)
      return false if data.nil?

      true
    end

    def valid_number?(value)
      data = value.try(:delete, ' ').to_s.match(/^[0-9]*$/)
      return false if data.nil?

      true
    end

    def valid_amount?(value)
      data = Float(value.to_s, exception: false)
      return false if data.nil? || data.negative? || data.zero?

      true
    end

    def valid_english_alphabets?(value)
      data = value.to_s.match(/^[A-Za-z ]*$/)
      return false if data.nil?

      true
    end

    def valid_company_name?(value)
      data = value.match(/^[a-zA-Z0-9_'&:.,@-]+( [a-zA-Z0-9_'&:.,@-]+)*$/)
      return false if data.nil?

      true
    end

    def valid_date?(value)
      return true if value == 'never'

      !(value.match(/\d{4}-\d{2}-\d{2}/) && Time.zone.strptime(value, '%Y-%m-%d')).nil?
    rescue ArgumentError
      false
    end

    def have_space?(value)
      data = value.match(/\s+/)
      return false if data.nil?

      true
    end

    def is_true_false(value)
      (value.is_a?(TrueClass) || value.is_a?(FalseClass)) || (value.downcase.eql?('true') || value.downcase.eql?('false'))
    end

    def is_true(value)
      (value.is_a?(TrueClass) || value.downcase.eql?('true'))
    end

    def valid_img_type?(value)
      data = value.match(%r{^data:image/(jpg|jpeg|png);base64,})
      return false if data.nil?

      true
    end

    def valid_identity_proof?(value)
      data = value.match(%r{^data:image/(jpg|jpeg|png|pdf);base64,})
      return false if data.nil?

      true
    end

    def valid_base64?(value)
      data = value.gsub(%r{^data:image/(jpg|jpeg|png);base64,}, '')

      data.blank? ? false : data.is_a?(String) && Base64.strict_encode64(Base64.decode64(data)) == data
    end

    def valid_json?(value)
      JSON.parse(value)
      true
    rescue JSON::ParserError => e
      false
    end

    def valid_url?(value)
      uri = URI.parse(value)
      uri.is_a?(URI::HTTP) && !uri.host.nil?
    rescue URI::InvalidURIError
      false
    end
  end
end
