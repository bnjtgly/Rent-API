module AdminApi
  class UpdateAgency
    include Interactor

    delegate :data, to: :context

    def call
      validate!
      build
    end

    def rollback; end

    private

    def build
      @agency = Agency.where(id: payload[:agency_id]).first

      @agency&.update(
        name: payload[:name],
        email: payload[:email],
        mobile_country_code_id: payload[:mobile_country_code_id],
        mobile: payload[:mobile],
        phone: payload[:phone],
        links: payload[:links],
        addresses: payload[:addresses]
      )
    end

    def validate!
      verify = AdminApi::UpdateAgencyValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        agency_id: data[:agency_id],
        name: data[:agency][:name],
        email: data[:agency][:email],
        mobile_country_code_id: data[:agency][:mobile_country_code_id],
        mobile: data[:agency][:mobile],
        phone: data[:agency][:phone],
        links: data[:agency][:links],
        addresses: data[:agency][:addresses]
      }
    end
  end
end
