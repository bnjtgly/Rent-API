module Custom
  class Ocr
    attr_accessor :resource
    def initialize(resource)
      @resource = resource
    end

    def call
      extract_text
    end

    private
    def extract_text
      image = RTesseract.new("#{Rails.root}/public/uploads/tmp/#{@resource}", lang: 'eng')

      # ap image.to_s[/Licence No.*/, 1]
      # ap image.to_s[/Date Of Birth.*/, 1]
      # ap image.to_s[/Expiry Date.*/, 1]
      #
      # ap image.to_box

      image.to_s
    end
  end
end

