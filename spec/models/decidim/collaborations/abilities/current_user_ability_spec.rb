# frozen_string_literal: true

require 'spec_helper'
require 'cancan/matchers'

describe Decidim::Collaborations::Abilities::CurrentUserAbility do
  let(:current_settings) { {} }
  subject { described_class.new(user, current_settings: current_settings) }

  let(:collaboration) { create(:collaboration) }
  let(:user) { create(:user, organization: collaboration.feature.organization) }

  context 'collaboration' do
    context 'collaboration allowed' do
      before do
        expect(current_settings).to receive(:collaborations_allowed?)
                                      .at_most(:once)
                                      .and_return(true)
      end

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
      before do
        expect(current_settings).to receive(:collaborations_allowed?)
                                      .at_most(:once)
                                      .and_return(false)
      end

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