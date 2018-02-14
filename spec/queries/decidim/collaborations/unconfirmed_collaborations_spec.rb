# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Collaborations
    describe UnconfirmedCollaborations do
      let(:subject) { described_class.new }
      let!(:pending_collaborations) do
        create_list(
          :user_collaboration,
          10,
          :punctual,
          :pending
        )
      end

      let!(:accepted_collaborations) do
        create_list(
          :user_collaboration,
          10,
          :punctual,
          :accepted
        )
      end

      let!(:rejected_collaborations) do
        create_list(
          :user_collaboration,
          10,
          :rejected,
          :punctual
        )
      end

      it "contains pending collaborations" do
        expect(subject).to include(*pending_collaborations)
        expect(subject).not_to include(*accepted_collaborations)
        expect(subject).not_to include(*rejected_collaborations)
      end
    end
  end
end
