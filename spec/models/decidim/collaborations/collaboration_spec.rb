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
          it 'returns false' do
            expect(collaboration).to receive(:total_collected)
                                       .and_return(target_amount)
            expect(collaboration.accepts_donations?).to be_falsey
          end
        end
      end

      context 'percentages and totals' do
        let!(:pending_user_collaboration) do
          create :user_collaboration,
                 :pending,
                 :punctual,
                 collaboration: collaboration,
                 amount: collaboration.target_amount / 2
        end

        let!(:rejected_user_collaboration) do
          create :user_collaboration,
                 :rejected,
                 :punctual,
                 collaboration: collaboration,
                 amount: collaboration.target_amount / 2
        end

        let!(:accepted_user_collaboration) do
          create :user_collaboration,
                 :accepted,
                 :punctual,
                 collaboration: collaboration,
                 amount: collaboration.target_amount / 2
        end

        context 'percentage' do
          it 'percentage reflects only accepted collaborations' do
            expect(collaboration.percentage).to eq(50)
          end
        end

        context 'user percentage' do
          it 'Reflects user percentage for accepted collaborations' do
            expect(collaboration.user_percentage(accepted_user_collaboration.user)).to eq(50)
          end

          it 'Do not reflects user percentage for rejected collaborations' do
            expect(collaboration.user_percentage(rejected_user_collaboration.user)).to eq(0)
          end

          it 'Do not reflects user percentage for pending collaborations' do
            expect(collaboration.user_percentage(pending_user_collaboration.user)).to eq(0)
          end
        end

        context 'user_total_collected' do
          it 'accepted collaborations are taken into consideration' do
            expect(collaboration.user_total_collected(accepted_user_collaboration.user)).to eq(accepted_user_collaboration.amount)
          end

          it 'rejected collaborations are not taken into consideration' do
            expect(collaboration.user_total_collected(rejected_user_collaboration.user)).to eq(0)
          end

          it 'pending collaborations are not taken into consideration' do
            expect(collaboration.user_total_collected(pending_user_collaboration.user)).to eq(0)
          end
        end
      end

      context 'recurrent_donation_allowed?' do
        let(:collaboration) { create :collaboration }

        context 'assemblies' do
          let(:collaboration) { create :collaboration, :assembly }

          it 'accept recurrent donations' do
            expect(subject).to  be_recurrent_donation_allowed
          end
        end

        context 'participatory process' do
          it "don't accept recurrent donations" do
            expect(subject).not_to  be_recurrent_donation_allowed
          end
        end
      end
    end
  end
end