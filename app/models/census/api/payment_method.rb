# frozen_string_literal: true

module Census
  module API
    # This class represents a payment method in Census
    class PaymentMethod < CensusAPI
      PAYMENT_METHOD_TYPES = %i[
        existing_payment_method
        direct_debit
        credit_card_external
      ].freeze

      # Sugar syntax to avoid creating a new instance of the API
      # when retrieving the list of payment methods available for
      # a user.
      def self.for_user(person_id)
        new.for_user(person_id)
      end

      # PUBLIC retrieve the available payment methods for the given user.
      def for_user(person_id)
        response = self.class.get(
          '/api/v1/payments/payment_methods',
          query: { person_id: person_id }
        )

        return [] if response.code != 200
        JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end
