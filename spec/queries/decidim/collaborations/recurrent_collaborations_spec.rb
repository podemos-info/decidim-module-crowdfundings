# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Collaborations
    describe RecurrentCollaborations do
      let(:collaboration) { create(:collaboration) }
      let(:organization) { collaboration.organization }
      let(:user) { create(:user, organization: organization) }
      let(:subject) { described_class.for_user(user) }

      describe "Recurrent collaborations for the user" do
        let(:collaborations) do
          create_list(:user_collaboration, 10,
                      frequency,
                      :accepted,
                      user: user,
                      collaboration: collaboration)
        end

        describe "monthly collaborations" do
          let(:frequency) { :monthly }

          it "are included" do
            expect(subject).to include(*collaborations)
          end
        end

        describe "quarterly collaborations" do
          let(:frequency) { :quarterly }

          it "are included" do
            expect(subject).to include(*collaborations)
          end
        end

        describe "annual collaborations" do
          let(:frequency) { :annual }

          it "are included" do
            expect(subject).to include(*collaborations)
          end
        end

        describe "punctual collaborations" do
          let(:frequency) { :punctual }

          it "are not included" do
            expect(subject).not_to include(*collaborations)
          end
        end
      end

      describe "Other users collaborations" do
        let(:monthly_collaborations) do
          create_list(:user_collaboration, 10, :monthly, :accepted, collaboration: collaboration)
        end

        let(:quarterly_collaborations) do
          create_list(:user_collaboration, 10, :quarterly, :accepted, collaboration: collaboration)
        end

        let(:annual_collaborations) do
          create_list(:user_collaboration, 10, :annual, :accepted, collaboration: collaboration)
        end

        let(:punctual_collaborations) do
          create_list(:user_collaboration, 10, :punctual, :accepted, collaboration: collaboration)
        end

        it "are not included" do
          expect(subject).not_to include(*monthly_collaborations)
          expect(subject).not_to include(*quarterly_collaborations)
          expect(subject).not_to include(*annual_collaborations)
          expect(subject).not_to include(*punctual_collaborations)
        end
      end
    end
  end
end
