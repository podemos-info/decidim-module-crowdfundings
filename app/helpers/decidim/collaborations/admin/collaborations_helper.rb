# frozen_string_literal: true

module Decidim
  module Collaborations
    module Admin
      # Helper methods for collaborations controller
      module CollaborationsHelper
        # Formats a number as a currency following the conventions and
        # settings predefined in the platform.d
        def decidim_number_to_currency(number)
          number_to_currency(number.nil? ? 0 : number,
                             unit: Decidim.currency_unit,
                             format: '%n %u')
        end
      end
    end
  end
end
