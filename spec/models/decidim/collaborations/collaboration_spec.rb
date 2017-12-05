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

      context 'accepts_supports?' do
        let(:active_until) { nil }
        let(:target_amount) { 10_000 }
        let(:total_collected) { 0 }
        let(:collaboration) do
          build :collaboration,
                target_amount: target_amount,
                active_until: active_until
        end

        before do
          stub_totals_request(total_collected)
        end

        context 'the collecting period has finished' do
          let(:active_until) { DateTime.now - 1.day }

          it 'returns false' do
            expect(collaboration.accepts_supports?).to be_falsey
          end
        end

        context 'Target amount has been satisfied' do
          let(:total_collected) { target_amount }

          it 'returns false' do
            expect(collaboration.accepts_supports?).to be_falsey
          end
        end

        context 'Census API returns error' do
          before do
            stub_totals_request_error
          end

          it 'returns false' do
            expect(collaboration.accepts_supports?).to be_falsey
          end
        end

        context 'Census API is down' do
          before do
            stub_totals_service_down
          end

          it 'returns nil' do
            expect(collaboration.percentage).to be_nil
          end
        end
      end

      context 'percentages and totals' do
        context 'percentage' do
          context 'API is up' do
            before do
              stub_totals_request(collaboration.target_amount / 2)
            end

            it 'percentage calculated from census response' do
              expect(collaboration.percentage).to eq(50)
            end
          end

          context 'API returns error' do
            before do
              stub_totals_request_error
            end

            it 'returns nil' do
              expect(collaboration.percentage).to be_nil
            end
          end

          context 'Census API is down' do
            before do
              stub_totals_service_down
            end

            it 'returns nil' do
              expect(collaboration.percentage).to be_nil
            end
          end
        end

        context 'user percentage' do
          let(:user) { create(:user, organization: collaboration.organization) }

          context 'Census API up' do
            before do
              stub_totals_request(collaboration.target_amount / 2)
            end

            it 'Percentage calculated from census response' do
              expect(collaboration.user_percentage(user)).to eq(50)
            end
          end

          context 'API returns error' do
            before do
              stub_totals_request_error
            end

            it 'returns nil' do
              expect(collaboration.user_percentage(user)).to be_nil
            end
          end

          context 'Census API is down' do
            before do
              stub_totals_service_down
            end

            it 'returns nil' do
              expect(collaboration.user_percentage(user)).to be_nil
            end
          end
        end

        context 'user_total_collected' do
          let(:user) { create(:user, organization: collaboration.organization) }
          let(:amount) { collaboration.target_amount / 2 }

          context 'Census API up' do
            before do
              stub_totals_request(amount)
            end

            it 'Value is retrieved from census API' do
              expect(collaboration.user_total_collected(user)).to eq(amount)
            end
          end

          context 'API returns error' do
            before do
              stub_totals_request_error
            end

            it 'returns nil' do
              expect(collaboration.user_total_collected(user)).to be_nil
            end
          end

          context 'Census API is down' do
            before do
              stub_totals_service_down
            end

            it 'returns nil' do
              expect(collaboration.user_total_collected(user)).to be_nil
            end
          end
        end
      end

      context 'recurrent_support_allowed?' do
        let(:collaboration) { create :collaboration }

        context 'assemblies' do
          let(:collaboration) { create :collaboration, :assembly }

          it 'accept recurrent supports' do
            expect(subject).to  be_recurrent_support_allowed
          end
        end

        context 'participatory process' do
          it "don't accept recurrent supports" do
            expect(subject).not_to  be_recurrent_support_allowed
          end
        end
      end
    end
  end
end