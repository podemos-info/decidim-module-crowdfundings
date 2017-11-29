# frozen_string_literal: true

module Decidim
  module Collaborations
    # Returns recurrent monthly user collaborations that must be renewed
    class PendingMonthlyCollaborations < Rectify::Query
      def query
        UserCollaboration.accepted.monthly
      end
    end
  end
end
