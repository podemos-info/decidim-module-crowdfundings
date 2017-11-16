# frozen_string_literal: true

module Decidim
  module Collaborations
    # This class holds a Form to create user collaborations
    class UserCollaborationForm < Decidim::Form
      mimic :user_collaboration

      attribute :amount, Integer

      validates :amount,
                presence: true,
                numericality: { only_integer: true, greater_than: 0 }

      validate :minimum_custom_amount

      private

      # This validator method checks that the amount set by the user is
      # higher or equal to the minimum value allowed for custom amounts
      def minimum_custom_amount

      end
    end
  end
end
