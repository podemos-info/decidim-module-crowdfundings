# frozen_string_literal: true

module Decidim
  module Collaborations
    # Helper methods for user collaboration controller views.
    module UserCollaborationsHelper
      # PUBLIC returns true if the confirmation form requires
      # extra payment data.
      def payment_data?(form)
        %w[existing_payment_method direct_debit].include? form&.payment_method_type
      end

      # PUBLIC true if the form needs an IBAN field
      def iban_field?(form)
        form&.payment_method_type == 'direct_debit'
      end

      # PUBLIC true if the forms needs a payment method selector
      def payment_method_select?(form)
        form&.payment_method_type == 'existing_payment_method'
      end
    end
  end
end
