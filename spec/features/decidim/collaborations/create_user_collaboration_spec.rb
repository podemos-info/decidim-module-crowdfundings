# frozen_string_literal: true

require 'spec_helper'

describe 'Create user collaboration', type: :feature do
  include_context 'with a feature'
  let(:manifest_name) { 'collaborations' }
  let!(:collaboration) { create(:collaboration, feature: feature) }
  let(:user) { create(:user, :confirmed, organization: organization) }
  let(:amount) { ::Faker::Number.number(4) }

  let(:payment_methods) do
    [
      { id: 1, name: 'Payment method 1'},
      { id: 2, name: 'Payment method 2'}
    ]
  end

  before do
    stub_payment_methods(payment_methods)
    stub_orders(order_http_response_code, order_response_json)
    stub_totals_request(0)

    login_as(user, scope: :user)

    visit_feature

    within '.new_user_collaboration' do
      find('label[for=amount_selector_other]').click
      fill_in :user_collaboration_amount, with: amount
      find(:css, "#user_collaboration_over_18[value='1']").set(true)
      find(:css, "#user_collaboration_accept_terms_and_conditions[value='1']").set(true)
    end
  end

  context 'Requests without external authorization' do
    let(:order_http_response_code) { 201 }
    let(:order_response_json) { { payment_method_id: 74 } }

    context 'Existing payment method' do
      before do
        within '.new_user_collaboration' do
          find('label[for=user_collaboration_payment_method_type_1]').click
          find('*[type=submit]').click
        end

        within '.confirm_user_collaboration' do
          find('*[type=submit]').click
        end

        page.driver.browser.switch_to.alert.accept
      end

      it 'Finish with success message' do
        expect(page).to have_content('You have successfully supported the collaboration campaign.')
      end
    end

    context 'Direct payment' do
      let(:iban) { 'ES5352192642521793064536' }

      before do
        within '.new_user_collaboration' do
          find('label[for=user_collaboration_payment_method_type_direct_debit]').click
          find('*[type=submit]').click
        end

        within '.confirm_user_collaboration' do
          fill_in :user_collaboration_iban, with: iban
          find('*[type=submit]').click

          page.driver.browser.switch_to.alert.accept
        end
      end

      it 'Finish with success message' do
        expect(page).to have_content('You have successfully supported the collaboration campaign.')
      end

      context 'Rejected request' do
        let(:order_http_response_code) { 422 }
        let(:order_response_json) { { errorCode: 1234, errorMessage: 'error message' } }

        it 'Operation fails' do
          expect(page).to have_content('Operation failed.')
        end
      end
    end
  end

  context 'Credit card' do
    let(:order_http_response_code) { 202 }
    let(:order_response_json) {
      {
        payment_method_id: 74,
        form: {
          action: 'https://sis-t.redsys.es:25443/sis/realizarPago',
          fields: {
            Ds_MerchantParameters: 'In real life this string is very long',
            Ds_SignatureVersion: 'HMAC_SHA256_V1',
            Ds_Signature: 'dNm0D9vbtal+1xWkNyG1PwzYHbE5RY+k6BdKfKogaaE='
          }
        }
      }
    }

    before do
      within '.new_user_collaboration' do
        find('label[for=user_collaboration_payment_method_type_credit_card_external]').click
        find('*[type=submit]').click
      end

      within '.confirm_user_collaboration' do
        find('*[type=submit]').click
      end

      page.driver.browser.switch_to.alert.accept
    end

    it 'Redirects to payment platform' do
      expect(page).to have_content('Importe')
      expect(page).to have_content('Código Comercio')
      expect(page).to have_content('Terminal')
      expect(page).to have_content('Número pedido')
    end
  end
end