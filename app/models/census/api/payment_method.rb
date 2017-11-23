# frozen_string_literal: true

module Census
  module API
    # This class represents a payment method in Census
    class PaymentMethod < CensusAPI
      PAYMENT_METHOD_TYPES = %i[existing_payment_method direct_debit credit_card_external]
    end
  end
end
