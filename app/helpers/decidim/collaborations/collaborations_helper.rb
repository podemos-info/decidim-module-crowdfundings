# frozen_string_literal: true

module Decidim
  module Collaborations
    # Helper methods for collaboration controller views.
    module CollaborationsHelper
      # Formats a number as a currency following the conventions and
      # settings predefined in the platform.d
      def decidim_number_to_currency(number)
        number_to_currency(number.nil? ? 0 : number,
                           unit: Decidim.currency_unit,
                           format: "%n %u")
      end

      # PUBLIC returns a list of frequency options that can be used
      # in a select input tag.
      def frequency_options
        UserCollaboration.frequencies.map do |frequency|
          [frequency_label(frequency[0]), frequency[0]]
        end
      end

      # PUBLIC Human readable frequency value
      def frequency_label(frequency)
        I18n.t(
          frequency.to_sym,
          scope: "decidim.collaborations.labels.frequencies"
        )
      end

      def state_label(user_collaboration_state)
        I18n.t(
          user_collaboration_state.to_sym,
          scope: "decidim.collaborations.labels.user_collaboration.states"
        )
      end

      # PUBLIC returns a list of payment method options that can
      # be used in a select input tag.
      def payment_method_options(except = nil)
        types = Census::API::PaymentMethod::PAYMENT_METHOD_TYPES - [except]
        types.map do |type|
          [payment_method_label(type), type]
        end
      end

      # PUBLIC Human readable payment method type value
      def payment_method_label(type)
        I18n.t(
          type.to_sym,
          scope: "decidim.collaborations.labels.payment_method_types"
        )
      end
    end
  end
end
