# frozen_string_literal: true

require 'spec_helper'

module Census
  module API
    describe PaymentMethod do
      let(:person_id) { 1 }
      let(:result) { ::Census::API::PaymentMethod.for_user(person_id) }

      context 'Communication error' do
        let(:response) do
          Net::HTTPServiceUnavailable.new('1.1', 503, 'Service Unavailable')
        end

        let(:exception) do
          Net::HTTPFatalError.new('503 Service Unavailable', response)
        end

        before do
          allow(::Census::API::PaymentMethod).to receive(:get)
                                           .with('/api/v1/payments/payment_methods', anything)
                                           .and_raise(exception)
        end

        it 'Returns structure with error code and message' do
          expect(result).to be_empty
        end
      end

      context 'Error response' do
        before do
          stub_request(:get, %r{/api/v1/payments/payment_methods})
            .to_return(
              status: 422,
              body: 'Error message',
              headers: {}
            )
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
          stub_request(:get, %r{/api/v1/payments/payment_methods})
            .to_return(
              status: 200,
              body: payment_methods.to_json,
              headers: {}
            )
        end

        it 'returns the list of payment methods' do
          expect(result).to eq(payment_methods)
        end
      end
    end
  end
end