module Custom
  module Ocr
    def extract_text(source)
      image = RTesseract.new("#{Rails.root}/#{source}")
      image.to_s
    end
  end
end

