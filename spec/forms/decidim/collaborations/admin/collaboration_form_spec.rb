# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Collaborations
    module Admin
      describe CollaborationForm do
        let(:organization) { create(:organization) }
        let(:participatory_process) { create :participatory_process, organization: organization }
        let(:current_feature) { create :collaboration_feature, participatory_space: participatory_process }

        let(:context) do
          {
            current_organization: organization,
            current_feature: current_feature
          }
        end

        let(:title) { Decidim::Faker::Localized.sentence(3) }
        let(:description) { Decidim::Faker::Localized.sentence(3) }
        let(:default_amount) { ::Faker::Number.number(2) }
        let(:maximum_authorized_amount) { ::Faker::Number.number(3) }
        let(:target_amount) { ::Faker::Number.number(5) }

        let(:attributes) do
          {
            title: title,
            description: description,
            default_amount: default_amount,
            maximum_authorized_amount: maximum_authorized_amount,
            target_amount: target_amount,
            active_until: (DateTime.now + 60.days).strftime('%Y-%m-%d')
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

        context 'maximum_authorized_amount' do
          context 'is missing' do
            let(:maximum_authorized_amount) { nil }
            it { is_expected.not_to be_valid }
          end

          context 'is less or equal 0' do
            let(:maximum_authorized_amount) { 0 }
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
      end
    end
  end
end
