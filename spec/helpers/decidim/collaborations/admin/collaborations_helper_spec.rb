# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Collaborations
    module Admin
      describe CollaborationsHelper do
        context 'decidim_number_to_currency' do
          it 'formats number using decidim currency' do
            expect(helper.decidim_number_to_currency(100)).to end_with(" #{Decidim.currency_unit}")
          end
        end

        context 'amount_options' do
          let(:selectable_amounts_count) { Decidim::Collaborations.selectable_amounts.length }

          it 'contain options for all available values' do
            expect(helper.amount_options.size).to eq(selectable_amounts_count)
          end

          it 'can contain an extra option for others' do
            expect(helper.amount_options(true).size).to eq(selectable_amounts_count + 1)
          end
        end
      end
    end
  end
end