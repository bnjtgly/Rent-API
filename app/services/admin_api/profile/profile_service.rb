module AdminApi
  module Profile
    class ProfileService
      attr_accessor :users

      def initialize(users)
        @users = users
      end

      def call
        get_completion_percentage
      end

      private
      def get_completion_percentage
        @users.each do |user|
          # if user.user_role.role.role_name.eql?('USER')
            completion = get_percent(user.id)

            user[:profile_progress] = {
              personal_info: "#{completion[:personal_info].round(2)}%",
              addresses: "#{completion[:addresses].round(2)}%",
              identities: "#{completion[:identities].round(2)}%",
              incomes: "#{completion[:incomes].round(2)}%",
              pets: "#{completion[:pets].round(2)}%",
              flatmates: "#{completion[:flatmates].round(2)}%",
              total_progress: "#{(completion.values.sum / completion.size).round(2)}%"
            }
          # end
        end
      end

      def get_percent(user_id)
        percentage = {}
        percentage[:personal_info] = (get_col_with_value('users', user_id).percent_of get_num_columns_cnt('users'))
        percentage[:addresses] = (get_col_with_value('addresses', user_id).percent_of get_num_columns_cnt('addresses'))
        percentage[:identities] = (get_col_with_value('identities', user_id).percent_of (get_num_columns_cnt('identities') * 2))
        percentage[:incomes] = (get_col_with_value('incomes', user_id).percent_of get_num_columns_cnt('incomes'))
        percentage[:pets] = (get_col_with_value('pets', user_id).percent_of get_num_columns_cnt('pets'))
        percentage[:flatmates] = (get_col_with_value('flatmates', user_id).percent_of get_num_columns_cnt('flatmates'))

        percentage
      end

      def get_col_with_value(table, col_with_val = [], user_id)
        limit = 1
        model = table.singularize.camelize.safe_constantize

        model_sanitize = if table.eql?('users')
                           model.column_names & %w[first_name last_name email phone gender_id date_of_birth mobile_country_code_id mobile]
                         elsif table.eql?('addresses')
                           model.column_names.excluding(%w[id valid_thru created_at updated_at])
                         elsif table.eql?('identities')
                           model.column_names.excluding(%w[id_number])
                         else
                           model.column_names.excluding(%w[id created_at updated_at])
                         end

        limit = 2 if table.eql?('identities')
        model_user = model.where(user_id: user_id).order(created_at: :desc).limit(limit)
        model_user = model.where(id: user_id) if table.eql?('users')

        model_user.each do |row|
          model_sanitize.each do |col|
            unless row[col].nil?
              col_with_val << col
            end
          end
        end

        col_with_val.count
      end

      def get_num_columns_cnt(table)
        column_num = table.singularize.camelize.safe_constantize.column_names.excluding(%w[id created_at updated_at]).count
        if table.eql?('users')
          column_num = (table.singularize.camelize.safe_constantize.column_names & %w[first_name last_name email phone gender_id date_of_birth mobile_country_code_id mobile]).count
        elsif table.eql?('addresses')
          column_num = table.singularize.camelize.safe_constantize.column_names.excluding(%w[id valid_thru created_at updated_at]).count
        elsif table.eql?('identities')
          column_num = table.singularize.camelize.safe_constantize.column_names.excluding(%w[id_number]).count
        end

        column_num
      end

    end
  end
end

class Numeric
  def percent_of(n)
    self.to_f / n.to_f * 100.0
  end
end
