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
        desc: payload[:desc],
        phone: payload[:phone],
        url: payload[:url],
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
        desc: data[:agency][:desc],
        phone: data[:agency][:phone],
        url: data[:agency][:url]
      }
    end
  end
end
