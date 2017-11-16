# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Collaborations
    module Admin
      describe CollaborationForm do
        let(:organization) { create(:organization) }
        let(:participatory_process) do
          create :participatory_process, organization: organization
        end
        let(:step) do
          create(:participatory_process_step, participatory_process: participatory_process)
        end
        let(:current_feature) do
          create :collaboration_feature, participatory_space: participatory_process
        end

        let(:context) do
          {
            current_organization: organization,
            current_feature: current_feature
          }
        end

        let(:title) { Decidim::Faker::Localized.sentence(3) }
        let(:description) { Decidim::Faker::Localized.sentence(3) }
        let(:default_amount) { ::Faker::Number.number(2) }
        let(:minimum_custom_amount) { ::Faker::Number.number(3) }
        let(:target_amount) { ::Faker::Number.number(5) }
        let(:active_until) { step.end_date.strftime('%Y-%m-%d') }

        let(:attributes) do
          {
            title: title,
            description: description,
            default_amount: default_amount,
            minimum_custom_amount: minimum_custom_amount,
            target_amount: target_amount,
            active_until: active_until
          }
        end

        subject { described_class.from_params(attributes).with_context(context) }

        it { is_expected.to be_valid }

        describe 'when title is missing' do
          let(:title) { { en: nil } }
          it { is_expected.not_to be_valid }
        end

        describe 'when description is missing' do
          let(:description) { { en: nil } }
          it { is_expected.not_to be_valid }
        end

        context 'default_amount' do
          context 'is missing' do
            let(:default_amount) { nil }
            it { is_expected.not_to be_valid }
          end

          context 'is less or equal 0' do
            let(:default_amount) { 0 }
            it { is_expected.not_to be_valid }
          end
        end

        context 'minimum_custom_amount' do
          context 'is missing' do
            let(:minimum_custom_amount) { nil }
            it { is_expected.not_to be_valid }
          end

          context 'is less or equal 0' do
            let(:minimum_custom_amount) { 0 }
            it { is_expected.not_to be_valid }
          end
        end

        context 'target_amount' do
          context 'is missing' do
            let(:target_amount) { nil }
            it { is_expected.not_to be_valid }
          end

          context 'is less or equal 0' do
            let(:target_amount) { 0 }
            it { is_expected.not_to be_valid }
          end
        end

        context 'active_until' do
          context "is valid when it's blank" do
            let(:active_until) { '' }
            it { is_expected.to be_valid }
          end

          context 'is valid when it is inside step bounds' do
            let(:active_until) { (step.end_date - 1.day).strftime('%Y-%m-%d') }
            it { is_expected.to be_valid }
          end

          context 'is invalid when it is outside step bounds' do
            let(:active_until) { (step.end_date + 1.day).strftime('%Y-%m-%d') }
            it { is_expected.not_to be_valid }
          end
        end
      end
    end
  end
end
