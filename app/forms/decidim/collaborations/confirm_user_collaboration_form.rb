# frozen_string_literal: true
module Decidim
  module Collaborations
    # This class holds a Form to confirm user collaborations
    class ConfirmUserCollaborationForm < UserCollaborationForm
      mimic :user_collaboration

      attribute :iban, String

      validates :iban, presence: true, if: :direct_debit?
      validates :iban, iban: true, unless: proc { |form| form.iban.blank? }

      private

      def direct_debit?
        payment_method_type == 'direct_debit'
      end
    end
  end
end