# frozen_string_literal: true

require 'spec_helper'

describe 'Collaborations view', type: :feature do
  include_context 'feature'
  let(:manifest_name) { 'collaborations' }
  let(:active_until) { nil }
  let!(:collaboration) do
    create(:collaboration, feature: feature, active_until: active_until)
  end
  let(:user) { create(:user, :confirmed, organization: organization) }

  before do
    login_as(user, scope: :user)
  end

  context 'Census API is down' do
    before do
      stub_totals_service_down
      visit_feature
    end

    it 'Gives feedback about status' do
      expect(page).to have_content('Collaboration is not allowed at this moment.')
    end
  end

  context 'User has reached his maximum per year' do
    before do
      allow(Census::API::Totals).to receive(:campaign_totals).with(collaboration.id).and_return(0)
      allow(Census::API::Totals).to receive(:user_totals)
                                .with(user.id)
                                .and_return(Decidim::Collaborations.maximum_annual_collaboration)
      allow(Census::API::Totals).to receive(:user_campaign_totals)
                                      .with(user.id, collaboration.id)
                                      .and_return(0)
      visit_feature
    end

    it 'Gives feedback about status' do
      expect(page).to have_content('You can not create more collaborations. You have reached the maximum yearly allowed.')
    end
  end

  context 'Target amount reached' do
    before do
      allow(Census::API::Totals).to receive(:campaign_totals)
                                      .with(collaboration.id)
                                      .and_return(collaboration.target_amount)
      allow(Census::API::Totals).to receive(:user_totals)
                                      .with(user.id)
                                      .and_return(0)

      allow(Census::API::Totals).to receive(:user_campaign_totals)
                                      .with(user.id, collaboration.id)
                                      .and_return(0)
      visit_feature
    end

    it 'Gives feedback about status' do
      expect(page).to have_content('The target amount has been reached. This campaign do not accepts more collaborations.')
    end
  end

  context 'Out of collaboration period' do
    let(:active_until) { Date.today - 1.day }

    before do
      stub_totals_request(0)
      visit_feature
    end

    it 'Gives feedback about status' do
      expect(page).to have_content('The period for accepting collaborations has expired.')
    end
  end
end
