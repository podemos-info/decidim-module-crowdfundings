# frozen_string_literal: true

require 'spec_helper'

describe 'Explore collaborations', type: :feature do
  include_context 'feature'
  let(:manifest_name) { 'collaborations' }
  let!(:collaboration) { create(:collaboration, feature: feature) }
  let!(:user_collaboration) do
    create(:user_collaboration, :accepted, collaboration: collaboration, amount: collaboration.target_amount / 2)
  end
  let(:user) { user_collaboration.user }

  before do
    visit_feature
    find_link(translated(collaboration.title)).click
  end

  context 'show' do
    it 'Contains collaboration details' do
      expect(page).to have_content(translated(collaboration.title))
      expect(page).to have_content(strip_tags(translated(collaboration.description)))
    end

    it 'Contains totals' do
      within '#overall-totals-block' do
        expect(page).to have_content(decidim_number_to_currency(collaboration.total_collected))
        expect(page).to have_content("OVERALL PERCENTAGE: #{number_to_percentage(collaboration.percentage, precision: 0)}")
        expect(page).to have_content(decidim_number_to_currency(collaboration.target_amount))
      end
    end
  end
end