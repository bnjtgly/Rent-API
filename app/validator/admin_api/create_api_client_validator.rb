module AdminApi
  class CreateApiClientValidator
    include Helper::BasicHelper
    include ActiveModel::Model

    attr_accessor(
      :name
    )

    validate :required, :name_exist

    def submit
      persist!
    end

    private

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:name, REQUIRED_MESSAGE) if name.blank?
    end

    def name_exist
      if ApiClient.exists?(name: name.try(:downcase).try(:titleize).try(:strip))
        errors.add(:name, "#{PLEASE_CHANGE_MESSAGE} #{NAME_EXIST_MESSAGE}")
      end
    end
  end
end
