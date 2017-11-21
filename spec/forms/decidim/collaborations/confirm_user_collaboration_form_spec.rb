# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Collaborations
    describe ConfirmUserCollaborationForm do
      let(:collaboration) { create(:collaboration) }

      let(:amount) { ::Faker::Number.number(4) }
      let(:frequency) { 'punctual' }
      let(:payment_method_type) { 'credit_card_external' }
      let(:payment_method_id) { nil }
      let(:iban) { nil }

      let(:attributes) do
        {
          amount: amount,
          frequency: frequency,
          payment_method_type: payment_method_type,
          payment_method_id: payment_method_id,
          iban: iban
        }
      end

      let(:context) do
        {
          current_organization: collaboration.organization,
          current_feature: collaboration.feature,
          collaboration: collaboration
        }
      end

      subject { described_class.from_params(attributes).with_context(context) }

      it { is_expected.to be_valid }

      context 'existing_payment_method' do
        let(:payment_method_type) { 'existing_payment_method' }

        context 'payment method id missing' do
          let(:payment_method_id) { nil }
          it { is_expected.not_to be_valid }
        end

        context 'payment method id informed' do
          let(:payment_method_id) { 1234 }
          it { is_expected.to be_valid }
        end
      end

      context 'direct_debit' do
        let(:payment_method_type) { 'direct_debit' }

        context 'iban is missing' do
          let(:iban) { nil }
          it { is_expected.not_to be_valid }
        end

        context 'iban is invalid' do
          let(:iban) { 'Abcd1234' }
          it { is_expected.not_to be_valid }
        end

        context 'iban is valid' do
          let(:iban) { 'ES1022605877289079247850' }
          it { is_expected.to be_valid }
        end
      end
    end
  end
end