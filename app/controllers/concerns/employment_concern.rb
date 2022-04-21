module EmploymentConcern
  extend ActiveSupport::Concern

  def get_employment_completion_percentage(employment, is_create)

    company = get_percentage employment, 'company', is_create
    address = get_percentage employment, 'address', is_create
    document = get_document_percentage employment
    total_progress = [company, address, document]

    {
      company: "#{company}%",
      address: "#{address}%",
      document: "#{document}%",
      total_progress: "#{(total_progress.inject(0.0) { |sum, el| sum + el } / total_progress.size).round(2)}%"
    }
  end

  def get_percentage(resource, definition, is_create)
    emp_company_value = []
    resource_size = resource.try(:id) ? 1 : resource.length
    return 0 if resource.blank?

    case definition
    when 'company'
      employment_columns  = %w[company_name position tenure]
    when 'address'
      employment_columns = %w[state suburb address post_code]
    end

    employment_columns.map do |col|
      if is_create
        unless resource[col].nil?
          emp_company_value << col
        end
      else
        resource.map do |row|
          unless row[col].nil?
            emp_company_value << col
          end
        end
      end
    end

    (emp_company_value.length).percent_of (employment_columns.length * resource_size).round(2)
  end

  def get_document_percentage(resource)
    emp_docs_total = []
    resource_size = resource.try(:id) ? 1 : resource.length
    return 0 if resource.blank?

    if resource.try(:id)
      emp_docs_total << 100.0
    else
      resource.each do |row|
        if row.emp_documents
          emp_docs_total << 100.0
        else
          emp_docs_total << 0
        end
      end
    end

    (emp_docs_total.sum(0.0) / resource_size).round(2)
  end
end

class Numeric
  def percent_of(n)
    self.to_f / n.to_f * 100.0
  end
end