# frozen_string_literal: true

module AdminApi
  class CreateDomainReferenceValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :domain_id,
      :role,
      :sort_order,
      :display,
      :value_str,
      :status,
      :metadata
    )

    validate :required, :valid_status, :domain_id_exist, :role_exist, :valid_number, :value_exist, :sort_order_exist

    def submit
      init
      persist!
    end

    private

    def init
      @domain_exist = Domain.exists?(id: domain_id)
    end

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:domain_id, REQUIRED_MESSAGE) if domain_id.blank?
      errors.add(:role, REQUIRED_MESSAGE) if role.blank?
      errors.add(:sort_order, REQUIRED_MESSAGE) if sort_order.blank?
      errors.add(:display, REQUIRED_MESSAGE) if display.blank?
      errors.add(:value_str, REQUIRED_MESSAGE) if value_str.blank?
      errors.add(:status, REQUIRED_MESSAGE) if status.blank?
    end

    def valid_status
      v_status = DOMAIN_STATUSES.include? status
      unless v_status
        errors.add(:status,
                   "#{PLEASE_CHANGE_MESSAGE} Valid values are #{DOMAIN_STATUSES.to_sentence}.")
      end
    end

    def domain_id_exist
      errors.add(:domain_id, 'Domain ID is not found.') unless @domain_exist
    end

    def role_exist
      if role.length.eql?(role.uniq.length)
        role.each do |rl|
          errors.add(:role, "#{PLEASE_CHANGE_MESSAGE} Role does not exist.") unless Role.exists?(id: rl.try(:strip))
        end
      else
        errors.add(:role, "#{PLEASE_CHANGE_MESSAGE} Kindly check for duplicates.")
      end
    end

    def value_exist
      if @domain_exist && DomainReference.where(value_str: value_str.try(:downcase).try(:titleize)).where(domain_id: domain_id).first
        errors.add(:value_str, "#{PLEASE_CHANGE_MESSAGE} Please try again. Value Str already exist.")
      end
    end

    def valid_number
      errors.add(:sort_order, VALID_NUMBER_MESSAGE) if valid_number?(sort_order).eql?(false)
    end

    def sort_order_exist
      if @domain_exist && DomainReference.where(sort_order: sort_order).where(domain_id: domain_id).first
        errors.add(:sort_order, "#{PLEASE_CHANGE_MESSAGE} Sort Order already exist.")
      end
    end
  end
end
