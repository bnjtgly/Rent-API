module PmApi
  class CreateProperty
    include Interactor

    delegate :data, :current_user, to: :context

    def call
      validate!
      build
    end

    def rollback
      context.property&.destroy
    end

    private

    def build
      @property_data =  JSON.parse(payload.to_json)
      @property_exists = Property.where('details @> ?', { name: @property_data['details']['name'] }.to_json).load_async.first

      if @property_exists
        @property = @property_exists
      else
        @property = Property.new(payload)
        @property.agency_id = current_user.user_agency.agency.id
        Property.transaction do
          @property.save
        end
      end

      context.property = @property
    end

    def validate!
      verify = PmApi::CreatePropertyValidator.new(payload)
      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        details: data[:property][:details]
      }
    end
  end
end