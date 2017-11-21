# frozen_string_literal: true
require 'ibanizator'

module Decidim
  module Collaborations
    # This class holds a Form to confirm user collaborations
    class ConfirmUserCollaborationForm < UserCollaborationForm
      mimic :user_collaboration

      attribute :iban, String
      attribute :payment_method_id, Integer

      validates :iban, presence: true, if: :direct_debit?
      validates :payment_method_id, presence: true, if: :existing_payment_method?
      validate :valid_iban

      private

      def existing_payment_method?
        payment_method_type == 'existing_payment_method'
      end

      def direct_debit?
        payment_method_type == 'direct_debit'
      end

      def valid_iban
        return unless direct_debit?

        validator = Ibanizator.iban_from_string(iban)
        return if validator.valid?

        errors.add(
          :iban,
          I18n.t(
            'iban.invalid_value',
            scope: 'activemodel.errors.user_collaborations'
          )
        )
      end
    end
  end
end