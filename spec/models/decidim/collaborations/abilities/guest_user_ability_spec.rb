# frozen_string_literal: true

require 'spec_helper'
require 'cancan/matchers'

describe Decidim::Collaborations::Abilities::GuestUserAbility do
  let(:current_settings) { {} }
  let(:collaborations_allowed) { true }
  let(:collaboration) { create(:collaboration) }

  subject { described_class.new(nil, current_settings: current_settings) }

  before do
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
  end
end