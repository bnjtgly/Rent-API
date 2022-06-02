module Api
  class EmploymentService
    attr_accessor :employments, :is_create

    def initialize(employments, is_create)
      @employments = employments
      @is_create = is_create
    end

    def call
      get_employment_completion_percentage
    end

    private

    def get_employment_completion_percentage
      company = get_percentage 'company'
      address = get_percentage 'address'
      document = get_document_percentage
      total_progress = [company, address, document]

      {
        company: "#{company}%",
        address: "#{address}%",
        document: "#{document}%",
        total_progress: "#{(total_progress.inject(0.0) { |sum, el| sum + el } / total_progress.size).round(2)}%"
      }
    end

    def get_percentage(definition)
      emp_company_value = []
      employment_size = @employments.try(:id) ? 1 : @employments.length
      return 0 if @employments.blank?

      case definition
      when 'company'
        employment_columns  = %w[company_name position tenure]
      when 'address'
        employment_columns = %w[state suburb address post_code]
      end

      employment_columns.map do |col|
        if @is_create
          unless @employments[col].nil?
            emp_company_value << col
          end
        else
          @employments.map do |row|
            unless row[col].nil?
              emp_company_value << col
            end
          end
        end
      end

      (emp_company_value.length).percent_of (employment_columns.length * employment_size).round(2)
    end

    def get_document_percentage
      emp_docs_total = []
      employment_size = @employments.try(:id) ? 1 : @employments.length
      return 0 if @employments.blank?

      if @employments.try(:id)
        emp_docs_total << 100.0
      else
        @employments.each do |row|
          if row.emp_documents
            emp_docs_total << 100.0
          else
            emp_docs_total << 0
          end
        end
      end

      (emp_docs_total.sum(0.0) / employment_size).round(2)
    end
  end
end

class Numeric
  def percent_of(n)
    self.to_f / n.to_f * 100.0
  end
end
