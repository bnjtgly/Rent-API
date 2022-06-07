module PmApi
  module TenantApplications
    class TenantRankingService
      attr_accessor :tenants

      def initialize(tenants)
        @tenants = tenants
      end

      def call
        add_user_details get_tenant_score
      end

      private

      def get_tenant_score
        UserScore.includes(:user)
                 .where(user: { id: @tenants.pluck(:user_id) })
                 .group(:user_id)
                 .average(:score)
      end

      def add_user_details(tenant_scores)
        data = []
        tenant_scores.each do |tenant|
          user = User.where(id: tenant.first).first
          data << {
            user_id: user.id,
            complete_name: user.complete_name,
            email: user.email,
            avatar: user.avatar.url,
            overall_score: tenant.last.round(2),
            user_scores: user.user_scores
          }
        end

        data.sort_by { |k| k[:overall_score] }.reverse
      end

    end
  end
end
