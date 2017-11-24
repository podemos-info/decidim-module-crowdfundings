# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Collaborations
    describe UserCollaborationsHelper do
      let(:form) { {} }

      context 'iban_field?' do
        it 'existing_payment_method returns false' do
          expect(form).to receive(:payment_method_type).and_return('existing_payment_method')
          expect(helper.iban_field?(form)).to be_falsey
        end

        it 'direct_debit returns true' do
          expect(form).to receive(:payment_method_type).and_return('direct_debit')
          expect(helper.iban_field?(form)).to be_truthy
        end

        it 'credit_card_external returns false' do
          expect(form).to receive(:payment_method_type).and_return('credit_card_external')
          expect(helper.iban_field?(form)).to be_falsey
        end
      end
    end
  end
end