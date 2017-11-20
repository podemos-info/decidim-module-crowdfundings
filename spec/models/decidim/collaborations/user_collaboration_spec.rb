# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Collaborations
    describe UserCollaboration do
      let(:user_collaboration) { create :user_collaboration, :accepted, :punctual }
      subject { user_collaboration }

      it { is_expected.to be_valid }

      context 'without a user' do
        let(:user_collaboration) do
          build :user_collaboration, :accepted, :punctual, user: nil
        end

        it { is_expected.not_to be_valid }
      end

      context 'without a collaboration' do
        let(:user_collaboration) do
          build :user_collaboration,
                :accepted,
                :punctual,
                collaboration: nil,
                user: create(:user)
        end

        it { is_expected.not_to be_valid }
      end

      context 'without state' do
        let(:user_collaboration) do
          build :user_collaboration, :punctual, state: nil
        end
        it { is_expected.not_to be_valid }
      end

      context 'amount' do
        context 'without value' do
          let(:user_collaboration) do
            build :user_collaboration, :accepted, :punctual, amount: nil
          end
          it {is_expected.not_to be_valid }
        end

        context 'Zero value' do
          let(:user_collaboration) do
            build :user_collaboration, :accepted, :punctual, amount: 0
          end
          it {is_expected.not_to be_valid }
        end

        context 'Negative value' do
          let(:user_collaboration) do
            build :user_collaboration, :accepted, :punctual, amount: -1
          end
          it {is_expected.not_to be_valid }
        end
      end

      context 'without frequency' do
        let(:user_collaboration) do
          build :user_collaboration, :accepted, frequency: nil
        end
        it {is_expected.not_to be_valid }
      end
    end
  end
end