module Api
  module Profile
    class ProfileScoreService
      attr_accessor :user

      def initialize(user)
        @user = user
      end

      def call
        get_user_score
      end

      private
      def get_user_score
        # Return empty array if there are no user scores.
        return [] unless @user.user_scores

        # Variables.
        initial_score = 0

        # Get Score Category Type.
        score_category ||= DomainReference.includes(:domain).where(domains: { domain_number: 2801 }).pluck(:value_str)

        # Convert score category to hash as keys.
        category = score_category.each_with_object({}) { |key, val| val[key] = initial_score }

        # Get all user scores and store to hash.
        @user.user_scores.each do |score|
          category_type = score.ref_score_category_type.value_str
          if score_category.include? category_type
            category[score.ref_score_category_type.value_str] = score.score
          end
        end

        # Get average of scores.
        category['overall_score'] = (category.values.inject(0.0) { |sum, el| sum + el } / category.values.size).round(2)

        category
      end
    end
  end
end
