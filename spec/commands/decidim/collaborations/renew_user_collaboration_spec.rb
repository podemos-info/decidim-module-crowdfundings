# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Collaborations
    describe RenewUserCollaboration do
      let!(:user_collaboration) do
        create(
          :user_collaboration,
          :annual,
          :accepted,
          last_order_request_date: Date.today - 11.months - 1.day
        )
      end

      subject { described_class.new(user_collaboration) }

      context 'when the form is not valid' do
        before do
          expect(subject).to receive(:valid?).and_return(false)
        end

        it 'is not valid' do
          expect { subject.call }.to broadcast(:invalid)
        end
      end

      context 'Census service is down' do
        let(:response) do
          Net::HTTPServiceUnavailable.new('1.1', 503, 'Service Unavailable')
        end

        let(:exception) do
          Net::HTTPFatalError.new('503 Service Unavailable', response)
        end

        before do
          allow(::Census::API::Order).to receive(:post)
                                           .with('/api/v1/payments/orders', anything)
                                           .and_raise(exception)
        end

        it 'do not updates the collaboration' do
          subject.call
          user_collaboration.reload
          expect(user_collaboration.last_order_request_date).not_to eq(Date.today.beginning_of_month)
        end

        it 'is not valid' do
          expect { subject.call }.to broadcast(:invalid)
        end
      end

      context 'Census API rejects the request' do
        before do
          stub_request(:post, %r{/api/v1/payments/orders})
            .to_return(
              status: 422,
              body: { errorCode: 1, errorMessage: 'Error message'}.to_json,
              headers: {}
            )
        end

        it 'do not updates the collaboration' do
          subject.call
          user_collaboration.reload
          expect(user_collaboration.last_order_request_date).not_to eq(Date.today.beginning_of_month)
        end

        it 'is not valid' do
          expect { subject.call }.to broadcast(:invalid)
        end
      end

      context 'when everything is ok' do
        let(:json) do
          { payment_method_id: user_collaboration.payment_method_id }
        end

        before do
          stub_request(:post, %r{/api/v1/payments/orders})
            .to_return(
              status: 201,
              body: json.to_json,
              headers: {}
            )

          subject.call
          user_collaboration.reload
        end

        it 'last_order_request_date is updated' do
          expect(user_collaboration.last_order_request_date).to eq(Date.today.beginning_of_month)
        end
      end
    end
  end
end
