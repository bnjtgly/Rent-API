module Api
  class ProfileService
    def initialize(current_user)
      @current_user = current_user
    end

    def call
      get_completion_percentage
    end

    private
    def get_completion_percentage
      completion = get_percent
      completion[:total_progress] = completion.values.sum / completion.size

      {
        personal_info: "#{completion[:personal_info].round(2)}%",
        addresses: "#{completion[:addresses].round(2)}%",
        identities: "#{completion[:identities].round(2)}%",
        incomes: "#{completion[:incomes].round(2)}%",
        pets: "#{completion[:pets].round(2)}%",
        flatmates: "#{completion[:flatmates].round(2)}%",
        total_progress: "#{completion[:total_progress].round(2)}%"
      }
    end

    def get_percent
      percentage = {}
      percentage[:personal_info] = (get_col_with_value('users').percent_of get_num_columns_cnt('users'))
      percentage[:addresses] = (get_col_with_value('addresses').percent_of get_num_columns_cnt('addresses'))
      percentage[:identities] = (get_col_with_value('identities').percent_of (get_num_columns_cnt('identities') * 2))
      percentage[:incomes] = (get_col_with_value('incomes').percent_of get_num_columns_cnt('incomes'))
      percentage[:pets] = (get_col_with_value('pets').percent_of get_num_columns_cnt('pets'))
      percentage[:flatmates] = (get_col_with_value('flatmates').percent_of get_num_columns_cnt('flatmates'))

      percentage
    end

    def get_num_columns_cnt(table)
      column_num = table.singularize.camelize.safe_constantize.column_names.excluding(%w[id created_at updated_at]).count
      if table.eql?('users')
        column_num = (table.singularize.camelize.safe_constantize.column_names & %w[first_name last_name email phone gender_id date_of_birth mobile_country_code_id mobile]).count
      elsif table.eql?('addresses')
        column_num = table.singularize.camelize.safe_constantize.column_names.excluding(%w[id valid_thru created_at updated_at]).count
      # else
      #   table.singularize.camelize.safe_constantize.column_names.excluding(%w[id created_at updated_at]).count
      end

      column_num
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
      model_user = model.where(user_id: @current_user.id).order(created_at: :desc).limit(limit)
      model_user = model.where(id: @current_user.id) if table.eql?('users')

      model_user.each do |row|
        model_sanitize.each do |col|
          unless row[col].nil?
            col_with_val << col
          end
        end
      end

      col_with_val.count
    end
  end
end
