# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Collaborations
    describe UserCollaborationForm do
      let(:collaboration) { create(:collaboration) }

      let(:amount) { ::Faker::Number.number(4) }
      let(:frequency) { 'punctual' }
      let(:payment_method_type) { 'existing_payment_method' }

      let(:attributes) do
        {
          amount: amount,
          frequency: frequency,
          payment_method_type: payment_method_type
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

      context 'amount' do
        context 'is missing' do
          let(:amount) { nil }
          it { is_expected.not_to be_valid }
        end

        context 'is zero' do
          let(:amount) { 0 }
          it { is_expected.not_to be_valid }
        end

        context 'is a negative number' do
          let(:amount) { -1 }
          it { is_expected.not_to be_valid }
        end

        context 'is not an integer' do
          let(:amount) { 1.01 }
          it { is_expected.not_to be_valid }
        end

        context 'it is bellow the minimum valid' do
          let(:amount) { collaboration.minimum_custom_amount - 1 }
          it { is_expected.not_to be_valid }
        end
      end

      context 'when frequency is missing' do
        let(:frequency) { nil }
        it { is_expected.not_to be_valid }
      end

      context 'when payment method is missing' do
        let(:payment_method_type) { nil }
        it { is_expected.not_to be_valid }
      end
    end
  end
end
