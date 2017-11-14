# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Collaborations
    describe Collaboration do
      let(:collaboration) { create :collaboration }
      subject { collaboration }

      it { is_expected.to be_valid }

      context 'without a feature' do
        let(:collaboration) { build :collaboration, feature: nil }

        it { is_expected.not_to be_valid }
      end

      context 'accepts_donations?' do
        let(:active_until) { nil }
        let(:target_amount) { 10_000 }
        let(:total_collected) { 0 }
        let(:collaboration) do
          build :collaboration,
                target_amount: target_amount,
                total_collected: total_collected,
                active_until: active_until
        end

        context 'the collecting period has finished' do
          let(:active_until) { DateTime.now - 1.day }

          it 'returns false' do
            expect(collaboration.accepts_donations?).to be_falsey
          end
        end

        context 'Target amount has been satisfied' do
          let(:total_collected) { target_amount }

          it 'returns false' do
            expect(collaboration.accepts_donations?).to be_falsey
          end
        end
      end
    end
  end
end