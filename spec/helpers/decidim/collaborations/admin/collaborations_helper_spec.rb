# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Collaborations
    module Admin
      describe CollaborationsHelper do
        context 'decidim_number_to_currency' do
          it 'formats number using decidim currency' do
            expect(helper.decidim_number_to_currency(100)).to end_with("100.00 #{Decidim.currency_unit}")
          end

          it 'fallbacks to 0' do
            expect(helper.decidim_number_to_currency(0)).to end_with("0.00 #{Decidim.currency_unit}")
          end
        end
      end
    end
  end
end