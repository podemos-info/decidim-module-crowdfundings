# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Collaborations
    describe PendingAnnualCollaborations do
      let!(:date_limit) { Date.today.beginning_of_month - 11.months }

      let(:subject) { described_class.new }

      context 'Annual collaborations' do
        let!(:old_annual_collaborations) do
          create_list(
            :user_collaboration,
            10,
            :annual,
            :accepted,
            last_order_request_date: date_limit - 1.day
          )
        end

        let!(:recent_annual_collaborations) do
          create_list(
            :user_collaboration,
            10,
            :annual,
            :accepted,
            last_order_request_date: date_limit
          )
        end

        let!(:pending_annual_collaborations) do
          create_list(
            :user_collaboration,
            10,
            :annual,
            :pending,
            last_order_request_date: date_limit - 1.day
          )
        end

        let!(:rejected_annual_collaborations) do
          create_list(
            :user_collaboration,
            10,
            :annual,
            :rejected,
            last_order_request_date: date_limit - 1.day
          )
        end

        it 'Contains annual collaborations that need to be renewed' do
          expect(subject).to include(*old_annual_collaborations)
        end

        it 'Do not contains annual collaborations that do not need to be renewed' do
          expect(subject).not_to include(*recent_annual_collaborations)
        end

        it 'Do not contains inactive collaborations' do
          expect(subject).not_to include(*pending_annual_collaborations)
          expect(subject).not_to include(*rejected_annual_collaborations)
        end
      end
    end
  end
end