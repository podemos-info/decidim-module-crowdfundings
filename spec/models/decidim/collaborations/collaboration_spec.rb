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
    end
  end
end