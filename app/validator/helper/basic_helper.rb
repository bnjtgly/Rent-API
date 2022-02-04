module Helper
  module BasicHelper
    PLEASE_CHANGE_MESSAGE = 'Please Change.'
    NOT_FOUND = 'Record does not exist.'
    REQUIRED_MESSAGE = 'This field is required.'
    PASSWORD_REQUIREMENTS_MESSAGE = 'Password should have more than 6 characters including 1 lower letter, 1 uppercase letter, 1 number and 1 symbol.'
    EMAIL_EXIST_MESSAGE = 'Email already exist.'
    ENGLISH_ALPHABETS_ONLY_MESSAGE = 'Only english alphabets are allowed (letters only).'
    NAME_EXIST_MESSAGE = 'Name already exist.'
    VALID_NUMBER_MESSAGE = 'Please enter valid number.'
    VALID_DATE_MESSAGE = 'Please enter valid date. Date must be YYYY-MM-DD.'
    VALID_BOOLEAN_MESSAGE = 'Please enter a valid value. Must be true or false'
    USER_ID_NOT_FOUND = 'We do not recognize your Account. Please try again.'
    MOBILE_NOT_VERIFIED = 'Your mobile number is not verified. Please verify your mobile number first.'
    EMAIL_NOT_VERIFIED = 'Your email address is not verified. Please verify your email address first.'
    TABLE_NOT_EXIST_MESSAGE = 'Table does not exist.'
    COLUMN_NOT_EXIST_MESSAGE = 'Column does not exist.'

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

    def valid_english_alphabets?(value)
      data = value.to_s.match(/^[A-Za-z ]*$/)
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
  end
end