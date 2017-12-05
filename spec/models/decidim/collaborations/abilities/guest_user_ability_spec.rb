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

  context 'support collaboration' do
    context 'collaboration allowed' do
      let(:collaborations_allowed) { true }

      it 'when collaboration accepts supports' do
        expect(collaboration).to receive(:accepts_supports?).and_return(true)
        expect(subject).to be_able_to(:support, collaboration)
      end

      it 'when collaboration do not accepts supports' do
        expect(collaboration).to receive(:accepts_supports?).and_return(false)
        expect(subject).not_to be_able_to(:support, collaboration)
      end
    end

    context 'collaboration not allowed' do
      let(:collaborations_allowed) { false }

      it 'when collaboration accepts supports' do
        expect(collaboration).to receive(:accepts_supports?).and_return(true)
        expect(subject).not_to be_able_to(:support, collaboration)
      end

      it 'when collaboration do not accepts supports' do
        expect(collaboration).to receive(:accepts_supports?).and_return(false)
        expect(subject).not_to be_able_to(:support, collaboration)
      end
    end
  end
end