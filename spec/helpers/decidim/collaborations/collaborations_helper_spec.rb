# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Collaborations
    describe CollaborationsHelper do
      context 'frequency_options' do
        it 'returns an option per frequency value' do
          expect(helper.frequency_options.count).to eq(UserCollaboration.frequencies.count)
        end

        it 'each option is returned with its value and a valid translation' do
          helper.frequency_options.each do |option|
            expect(option[0]).to eq(I18n.t(
              option[1].to_sym,
              scope: 'decidim.collaborations.labels.frequencies'
            ))
          end
        end
      end
    end
  end
end