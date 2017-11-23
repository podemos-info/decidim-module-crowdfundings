# frozen_string_literal: true

require 'spec_helper'

describe 'Explore collaborations', type: :feature do
  let(:manifest_name) { 'collaborations' }
  let(:confirmed_user) { create(:user, :confirmed, organization: organization) }

  context 'Participatory process' do
    include_context 'feature'
    let!(:collaboration) { create(:collaboration, feature: feature) }
    let!(:user_collaboration) do
      create(:user_collaboration,
             :accepted,
             :punctual,
             collaboration: collaboration,
             amount: collaboration.target_amount / 2)
    end
    let(:user) { user_collaboration.user }

    before do
      login_as(confirmed_user, scope: :user)
      visit_feature
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

      it 'Frequency is punctual by default' do
        expect(find(:css, '#user_collaboration_frequency', visible: false).value).to eq('punctual')
      end
    end
  end

  context 'Assembly' do
    include_context 'assembly feature'
    let!(:collaboration) { create(:collaboration, feature: feature) }

    before do
      login_as(confirmed_user, scope: :user)
      visit_feature
    end

    context 'show' do
      it 'Frequency is monthly by default' do
        expect(page).to have_select('user_collaboration_frequency', selected: 'Monthly')
      end
    end
  end
end
