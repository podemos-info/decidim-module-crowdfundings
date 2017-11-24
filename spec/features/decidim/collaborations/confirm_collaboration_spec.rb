# frozen_string_literal: true

require 'spec_helper'

describe 'Confirm collaboration', type: :feature do
  include_context 'feature'
  let(:manifest_name) { 'collaborations' }
  let!(:collaboration) { create(:collaboration, feature: feature) }
  let(:user) { create(:user, :confirmed, organization: organization) }
  let(:amount) { ::Faker::Number.number(4) }

  before do
    login_as(user, scope: :user)

    visit_feature

    within '.new_user_collaboration' do
      find('label[for=amount_selector_other]').click
      fill_in :user_collaboration_amount, with: amount
    end
  end

  context 'Fill collaboration form' do
    context 'Existing payment method' do
      before do
        within '.new_user_collaboration' do
          find('label[for=user_collaboration_payment_method_type_existing_payment_method]').click
          find('*[type=submit]').click
        end
      end

      it 'navigates to confirm page' do
        expect(page).to have_content('COLLABORATION RESUME')
      end

      it 'Shows the amount' do
        expect(page).to have_content(decidim_number_to_currency(amount))
      end

      it 'Shows the frequency' do
        expect(page).to have_content('PUNCTUAL')
      end

      it 'Shows the payment method' do
        expect(page).to have_content('EXISTING PAYMENT METHOD')
      end

      it 'No extra fields are needed' do
        expect(page).not_to have_content('FILL THE FOLLOWING FIELDS')
      end
    end

    context 'Direct debit' do
      before do
        within '.new_user_collaboration' do
          find('label[for=user_collaboration_payment_method_type_direct_debit]').click
          find('*[type=submit]').click
        end
      end

      it 'navigates to confirm page' do
        expect(page).to have_content('COLLABORATION RESUME')
      end

      it 'Shows the amount' do
        expect(page).to have_content(decidim_number_to_currency(amount))
      end

      it 'Shows the frequency' do
        expect(page).to have_content('PUNCTUAL')
      end

      it 'Shows the payment method' do
        expect(page).to have_content('DIRECT DEBIT')
      end

      it 'IBAN needed' do
        expect(page).to have_content('FILL THE FOLLOWING FIELDS')
        expect(page).to have_field('IBAN')
      end
    end

    context 'Credit card' do
      before do
        within '.new_user_collaboration' do
          find('label[for=user_collaboration_payment_method_type_credit_card_external]').click
          find('*[type=submit]').click
        end
      end

      it 'navigates to confirm page' do
        expect(page).to have_content('COLLABORATION RESUME')
      end

      it 'Shows the amount' do
        expect(page).to have_content(decidim_number_to_currency(amount))
      end

      it 'Shows the frequency' do
        expect(page).to have_content('PUNCTUAL')
      end

      it 'Shows the payment method' do
        expect(page).to have_content('CREDIT CARD')
      end

      it 'No extra fields are needed' do
        expect(page).not_to have_content('FILL THE FOLLOWING FIELDS')
      end
    end

    context 'No payment method selected' do
      before do
        within '.new_user_collaboration' do
          find('*[type=submit]').click
        end
      end

      it 'renders the form again' do
        expect(page).to have_content('SELECT THE PAYMENT METHOD')
      end

      it 'shows an error message' do
        expect(page).to have_content('You must select a payment method.')
      end
    end
  end
end