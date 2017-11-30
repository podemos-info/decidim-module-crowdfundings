# frozen_string_literal: true

require 'spec_helper'

module Census
  module API
    describe PaymentMethod do
      let(:person_id) { 1 }
      let(:result) { ::Census::API::PaymentMethod.for_user(person_id) }

      context 'Communication error' do
        before do
          stub_payment_methods_service_down
        end

        it 'Returns structure with error code and message' do
          expect(result).to be_empty
        end
      end

      context 'Error response' do
        before do
          stub_payment_methods_error
        end

        it 'Returns structure with error code and message' do
          expect(result).to be_empty
        end
      end

      context 'Successful response' do
        let(:payment_methods) do
          [
            { id: 1, name: 'Payment method 1'},
            { id: 2, name: 'Payment method 2'}
          ]
        end

        before do
          stub_payment_methods(payment_methods)
        end

        it 'returns the list of payment methods' do
          expect(result).to eq(payment_methods)
        end
      end
    end
  end
end