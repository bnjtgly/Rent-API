class Api::CreateProperty
  include Interactor

  delegate :data, to: :context

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
    @property_exists = Property.where('details @> ?', { name: @property_data['details']['name'] }.to_json).first

    if !@property_exists
      @property = Property.new(payload)
      Property.transaction do
        @property.save
      end
    else

    end

    context.property = @property_exists
  end

  def validate!
    verify = Api::CreatePropertyValidator.new(payload)
    return true if verify.submit

    context.fail!(error: verify.errors)
  end

  def payload
    {
      details: data[:property][:details]
    }
  end
end
