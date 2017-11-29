# frozen_string_literal: true

module Decidim
  module Collaborations
    # Returns recurrent quarterly user collaborations that must be renewed
    class PendingQuarterlyCollaborations < Rectify::Query
      def query
        UserCollaboration.accepted.quarterly
      end
    end
  end
end
