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
                                      scope: 'decidim.collaborations.labels.frequencies'))
          end
        end
      end

      context 'decidim_number_to_currency' do
        it 'formats number using decidim currency' do
          expect(helper.decidim_number_to_currency(100)).to end_with("100.00 #{Decidim.currency_unit}")
        end

        it 'fallbacks to 0' do
          expect(helper.decidim_number_to_currency(0)).to end_with("0.00 #{Decidim.currency_unit}")
        end
      end

      context 'state_label' do
        it 'returns the translated value for each state' do
          UserCollaboration.states.each do |state|
            expect(helper.state_label(state[0])).to eq(I18n.t(
              state[0].to_sym,
              scope: 'decidim.collaborations.labels.user_collaboration.states'
            ))
          end
        end
      end
    end
  end
end