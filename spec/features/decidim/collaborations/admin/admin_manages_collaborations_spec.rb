# frozen_string_literal: true

require 'spec_helper'

describe 'Admin manages collaborations', type: :feature, serves_map: true do
  let(:manifest_name) { 'collaborations' }
  let!(:collaboration) { create :collaboration, feature: current_feature }

  include_context 'feature admin'

  it_behaves_like 'manage collaborations'
end