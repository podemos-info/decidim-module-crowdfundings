# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Collaborations
    module Admin
      describe UpdateCollaboration do
        let(:organization) { create(:organization) }
        let(:participatory_process) { create :participatory_process, organization: organization }
        let(:current_feature) { create :collaboration_feature, participatory_space: participatory_process }

        let(:context) do
          {
            current_organization: organization,
            current_feature: current_feature
          }
        end

        let(:collaboration) { create(:collaboration, feature: current_feature) }

        let(:title) { Decidim::Faker::Localized.sentence(3) }
        let(:description) { Decidim::Faker::Localized.sentence(3) }
        let(:default_amount) { ::Faker::Number.number(2).to_i }
        let(:maximum_authorized_amount) { ::Faker::Number.number(3).to_i }
        let(:target_amount) { ::Faker::Number.number(5).to_i }
        let(:active_until) { (DateTime.now + 60.days).strftime('%Y-%m-%d') }
        let(:form) do
          double(
            invalid?: invalid,
            title: title,
            description: description,
            default_amount: default_amount,
            maximum_authorized_amount: maximum_authorized_amount,
            target_amount: target_amount,
            active_until: active_until,
            current_feature: current_feature
          )
        end
        let(:invalid) { false }
        subject { described_class.new(form, collaboration) }

        context 'when the form is not valid' do
          let(:invalid) { true }

          it 'is not valid' do
            expect { subject.call }.to broadcast(:invalid)
          end
        end

        context 'when everything is ok' do
          let(:project) { Decidim::Collaborations::Collaboration.last }

          it 'sets all attributes received from the form' do
            subject.call
            expect(project.title).to eq title
            expect(project.description).to eq description
            expect(project.default_amount).to eq default_amount
            expect(project.maximum_authorized_amount).to eq maximum_authorized_amount
            expect(project.target_amount).to eq target_amount
            expect(project.active_until.strftime('%Y-%m-%d')).to eq active_until
          end
        end
      end
    end
  end
end
