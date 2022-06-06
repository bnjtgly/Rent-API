module PmApi
  class ProfileScoreService
    attr_accessor :resources

    def initialize(resources)
      @resources = resources
    end

    def call
      add_details
    end

    private
    def add_details
      # If more than 1 record.
      if @resources.kind_of?(Array)
        @resources.each do |resource|
          resource[:overall_score] = get_user_score(resource.user)[:overall_score]
        end
      #  If single record.
      else
        get_user_score(@resources.user)[:overall_score]
      end

    end

    def get_user_score(user)
      # Return empty array if there are no user scores.
      return nil unless user.user_scores

      # Variables.
      initial_score = 0

      # Get Score Category Type.
      # Domain number: 2801, name: 'Score Category Type'.
      # Memoize
      score_category ||= DomainReference.includes(:domain).where(domains: { domain_number: 2801 }).pluck(:value_str)

      # Convert score category to hash as keys.
      category = score_category.each_with_object({}) { |key, val| val[key] = initial_score }

      # Get all user scores and store to hash.
      user.user_scores.each do |score|
        category_type = score.ref_score_category_type.value_str
        if score_category.include? category_type
          category[score.ref_score_category_type.value_str] = score.score
        end
      end

      # Get average value of scores.
      category[:overall_score] = (category.values.inject(0.0) { |sum, el| sum + el } / category.values.size).round(2)

      category
    end
  end
end
