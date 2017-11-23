# frozen_string_literal: true
module Decidim
  module Collaborations
    # This class holds a Form to confirm user collaborations
    class ConfirmUserCollaborationForm < UserCollaborationForm
      mimic :user_collaboration

      attribute :iban, String
      attribute :payment_method_id, Integer

      validates :iban, presence: true, if: :direct_debit?
      validates :iban, iban: true, unless: Proc.new { |form| form.iban.blank? }
      validates :payment_method_id, presence: true, if: :existing_payment_method?

      private

      def existing_payment_method?
        payment_method_type == 'existing_payment_method'
      end

      def direct_debit?
        payment_method_type == 'direct_debit'
      end
    end
  end
end