# frozen_string_literal: true

require 'spec_helper'

describe Decidim::Collaborations::Collaboration do
  let(:collaboration) { create :collaboration }
  subject { collaboration }

  it { is_expected.to be_valid }

  context 'without a feature' do
    let(:collaboration) { build :collaboration, feature: nil }

    it { is_expected.not_to be_valid }
  end
end