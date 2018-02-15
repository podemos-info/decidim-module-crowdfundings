# frozen_string_literal: true

require 'spec_helper'

describe 'Collaborations view', type: :system do
  let(:manifest_name) { 'collaborations' }
  let(:confirmed_user) { create(:user, :confirmed, organization: organization) }

  let(:payment_methods) do
    [
      { id: 1, name: 'Payment method 1'},
      { id: 2, name: 'Payment method 2'}
    ]
  end

  before do
    stub_payment_methods(payment_methods)
    stub_totals_request(500)
  end

  context 'Participatory process' do
    include_context 'with a feature'
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
        frequency = find(:css, '#user_collaboration_frequency', visible: false)
        expect(frequency.value).to eq('punctual')
      end

      it 'User payment methods are selectable' do
        payment_methods.each do |method|
          expect(page).to have_content(method[:name])
        end
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
        amount = find(
          :radio_button,
          'user_collaboration[frequency]',
          checked: true,
          visible: false
        )
        expect(amount.value).to eq('monthly')
      end
    end
  end
end
