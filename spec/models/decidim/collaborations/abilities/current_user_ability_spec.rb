# frozen_string_literal: true

require 'spec_helper'
require 'cancan/matchers'

describe Decidim::Collaborations::Abilities::CurrentUserAbility do
  let(:current_settings) { {} }
  let(:user_annual_accumulated) { 0 }
  let(:collaborations_allowed) { true }
  let(:collaboration) { create(:collaboration) }
  let(:user) { create(:user, organization: collaboration.feature.organization) }

  subject { described_class.new(user, current_settings: current_settings) }

  before do
    stub_totals_request(user_annual_accumulated)
    expect(current_settings).to receive(:collaborations_allowed?)
                                  .at_most(:once)
                                  .and_return(collaborations_allowed)
  end

  context 'donate to collaboration' do
    context 'collaboration allowed' do
      let(:collaborations_allowed) { true }

      it 'let the user donate when collaboration accepts donations' do
        expect(collaboration).to receive(:accepts_donations?).and_return(true)
        expect(subject).to be_able_to(:donate, collaboration)
      end

      it 'Do not let the user donate when collaboration do not accepts donations' do
        expect(collaboration).to receive(:accepts_donations?).and_return(false)
        expect(subject).not_to be_able_to(:donate, collaboration)
      end
    end

    context 'collaboration not allowed' do
      let(:collaborations_allowed) { false }

      it 'do not let the user donate when collaboration accepts donations' do
        expect(collaboration).to receive(:accepts_donations?).and_return(true)
        expect(subject).not_to be_able_to(:donate, collaboration)
      end

      it 'Do not let the user donate when collaboration do not accepts donations' do
        expect(collaboration).to receive(:accepts_donations?).and_return(false)
        expect(subject).not_to be_able_to(:donate, collaboration)
      end
    end

    context 'Maximum annual per user validation' do
      context 'User is in the limit' do
        let(:user_annual_accumulated) { Decidim::Collaborations.maximum_annual_collaboration }

        it 'User is not allowed to donate' do
          expect(subject).not_to be_able_to(:donate, collaboration)
        end
      end

      context 'User is under the limit' do
        let(:user_annual_accumulated) { 0 }

        it 'User is allowed to donate' do
          expect(subject).to be_able_to(:donate, collaboration)
        end
      end
    end
  end

  context 'donate_recurrently' do
    context 'First user recurrent collaboration' do
      before do
        allow(collaboration).to receive(:recurrent_donation_allowed?).and_return(true)
      end

      it 'User can do a recurrent donation' do
        expect(subject).to be_able_to(:donate_recurrently, collaboration)
      end
    end

    context 'User already has a recurrent collaboration' do
      let!(:user_collaboration) do
        create(:user_collaboration, :monthly, :accepted, collaboration: collaboration)
      end

      it 'User can not do a recurrent donation' do
        expect(subject).not_to be_able_to(:donate_recurrently, collaboration)
      end
    end
  end
end