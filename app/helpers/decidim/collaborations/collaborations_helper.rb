# frozen_string_literal: true

module Decidim
  module Collaborations
    # Helper methods for collaboration controller views.
    module CollaborationsHelper
      # PUBLIC returns a list of frequency options that can be used
      # in a select input tag.
      def frequency_options
        UserCollaboration.frequencies.map do |frequency|
          [
            I18n.t(
              frequency[0].to_sym,
              scope: 'decidim.collaborations.labels.frequencies'
            ),
            frequency[0]
          ]
        end
      end
    end
  end
end
