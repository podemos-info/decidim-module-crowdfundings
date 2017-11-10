# frozen_string_literal: true

module Decidim
  module Collaborations
    module Admin
      # Helper methods for collaborations controller
      module CollaborationsHelper
        # Generates a list of options that can be used in a select control
        # with all available selectable ammounts defined for the platform.
        def amount_options(include_others = false)
          result = []
          Decidim::Collaborations.selectable_amounts.each do |amount|
            result << [
              decidim_number_to_currency(amount),
              amount
            ]
          end

          if include_others
            result << [
              I18n.t('labels.other', scope: 'decidim.collaborations.'),
              nil
            ]
          end

          result
        end

        # Formats a number as a currencty following the convenions and
        # settings predefined in the platform.d
        def decidim_number_to_currency(number)
          number_to_currency(number,
                             unit: Decidim.currency_unit,
                             format: '%n %u')
        end
      end
    end
  end
end
