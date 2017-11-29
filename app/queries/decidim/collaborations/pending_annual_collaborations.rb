# frozen_string_literal: true

module Decidim
  module Collaborations
    # Returns recurrent annual user collaborations that must be renewed
    class PendingAnnualCollaborations < Rectify::Query
      def query
        UserCollaboration.accepted.annual
      end
    end
  end
end
