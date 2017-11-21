# frozen_string_literal: true

module Decidim
  module Collaborations
    # This class holds a Form to create user collaborations
    class UserCollaborationForm < Decidim::Form
      mimic :user_collaboration

      attribute :amount, Integer
      attribute :frequency, String
      attribute :payment_method_type, String

      validates :amount,
                presence: true,
                numericality: { only_integer: true, greater_than: 0 }

      validates :frequency, presence: true
      validates :payment_method_type, presence: true
      validate :minimum_custom_amount

      private

      # This validator method checks that the amount set by the user is
      # higher or equal to the minimum value allowed for custom amounts
      def minimum_custom_amount
        return if amount.nil?
        return if context.collaboration.amounts.include? amount
        return if amount >= context.collaboration.minimum_custom_amount

        errors.add(
          :amount,
          I18n.t(
            'amount.minimum_valid_amount',
            amount: context.collaboration.minimum_custom_amount,
            scope: 'activemodel.errors.user_collaborations'
          )
        )
      end
    end
  end
end
