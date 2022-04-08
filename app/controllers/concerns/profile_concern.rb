module ProfileConcern
  extend ActiveSupport::Concern

  def get_profile_completion_percentage
      personal_info = (get_col_with_value('users').percent_of get_num_columns_cnt('users'))
      addresses = (get_col_with_value('addresses').percent_of get_num_columns_cnt('addresses'))
      identities = (get_col_with_value('identities').percent_of (get_num_columns_cnt('identities') * 2))
      incomes = (get_col_with_value('incomes').percent_of get_num_columns_cnt('incomes'))
      pets = (get_col_with_value('pets').percent_of get_num_columns_cnt('pets'))
      flatmates = (get_col_with_value('flatmates').percent_of get_num_columns_cnt('flatmates'))
      total_progress = [personal_info, addresses, identities, incomes, pets, flatmates]
    {
      personal_info: "#{personal_info.round(2)}%",
      addresses: "#{addresses.round(2)}%",
      identities: "#{identities.round(2)}%",
      incomes: "#{incomes.round(2)}%",
      pets: "#{pets.round(2)}%",
      flatmates: "#{flatmates.round(2)}%",
      total_progress: "#{(total_progress.inject(0.0) { |sum, el| sum + el } / total_progress.size).round(2)}%"
    }
  end

  def get_num_columns_cnt(table)
    if table.eql?('users')
      (table.singularize.camelize.safe_constantize.column_names & %w[first_name last_name email phone gender_id date_of_birth mobile_country_code_id mobile]).count
    elsif table.eql?('addresses')
      table.singularize.camelize.safe_constantize.column_names.excluding(%w[id valid_thru created_at updated_at]).count
    else
      table.singularize.camelize.safe_constantize.column_names.excluding(%w[id created_at updated_at]).count
    end
  end

  def get_col_with_value(table, col_with_val = [])
    limit = 1
    model = table.singularize.camelize.safe_constantize

    model_sanitize = if table.eql?('users')
                       model.column_names & %w[first_name last_name email phone gender_id date_of_birth mobile_country_code_id mobile]
                     elsif table.eql?('addresses')
                       model.column_names.excluding(%w[id valid_thru created_at updated_at])
                     else
                       model.column_names.excluding(%w[id created_at updated_at])
                     end

    limit = 2 if table.eql?('identities')
    model_user = model.where(user_id: current_user.id).order(created_at: :desc).limit(limit)
    model_user = model.where(id: current_user.id) if table.eql?('users')

    model_user.each do |row|
      model_sanitize.each do |col|
        unless row[col].nil?
          col_with_val << col
        end
      end
    end

    col_with_val.count
  end

  # def get_profile_diff(old, new)
  #   old.diff(new)
  # end
end

class Numeric
  def percent_of(n)
    self.to_f / n.to_f * 100.0
  end
end

class Hash
  def diff(other)
    result = {}
    self.keys.each do |key|
      if self[key] != other[key]
        result[key] = other[key]
      end
    end
    result
  end
end
