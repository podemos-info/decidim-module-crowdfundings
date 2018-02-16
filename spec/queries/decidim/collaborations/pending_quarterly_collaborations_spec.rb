# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Collaborations
    describe PendingQuarterlyCollaborations do
      let(:subject) { described_class.new }

      describe "Annual collaborations" do
        let(:date_limit) { Time.zone.today.beginning_of_month - 11.months }

        let!(:annual_collaborations) do
          create_list(
            :user_collaboration,
            10,
            :annual,
            :accepted,
            last_order_request_date: date_limit - 1.day
          )
        end

        it "Do not Contains annual collaborations" do
          expect(subject).not_to include(*annual_collaborations)
        end
      end

      describe "Quarterly collaborations" do
        let!(:date_limit) { Time.zone.today.beginning_of_month - 2.months }

        let!(:old_collaborations) do
          create_list(
            :user_collaboration,
            10,
            :quarterly,
            :accepted,
            last_order_request_date: date_limit - 1.day
          )
        end

        let!(:recent_collaborations) do
          create_list(
            :user_collaboration,
            10,
            :quarterly,
            :accepted,
            last_order_request_date: date_limit
          )
        end

        let!(:pending_collaborations) do
          create_list(
            :user_collaboration,
            10,
            :quarterly,
            :pending,
            last_order_request_date: date_limit - 1.day
          )
        end

        let!(:rejected_collaborations) do
          create_list(
            :user_collaboration,
            10,
            :quarterly,
            :rejected,
            last_order_request_date: date_limit - 1.day
          )
        end

        it "Contains collaborations that need to be renewed" do
          expect(subject).to include(*old_collaborations)
        end

        it "Do not contains collaborations that do not need to be renewed" do
          expect(subject).not_to include(*recent_collaborations)
        end

        it "Do not contains inactive collaborations" do
          expect(subject).not_to include(*pending_collaborations)
          expect(subject).not_to include(*rejected_collaborations)
        end
      end
    end
  end
end
