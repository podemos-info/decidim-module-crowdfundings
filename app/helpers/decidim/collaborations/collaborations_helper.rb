# frozen_string_literal: true

module Decidim
  module Collaborations
    # Helper methods for collaboration controller views.
    module CollaborationsHelper
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
          scope: 'decidim.collaborations.labels.frequencies'
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
          scope: 'decidim.collaborations.labels.payment_method_types'
        )
      end
    end
  end
end
