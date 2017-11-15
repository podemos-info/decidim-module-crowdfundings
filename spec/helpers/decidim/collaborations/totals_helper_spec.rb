# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Collaborations
    describe TotalsHelper do
      context 'percentage_class' do
        it 'percentage between 0 and 40: level1' do
          expect(helper.percentage_class(10)).to eq('percentage--level1')
        end

        it 'percentage between 40 and 60: level2' do
          expect(helper.percentage_class(50)).to eq('percentage--level2')
        end

        it 'percentage between 60 and 80: level3' do
          expect(helper.percentage_class(70)).to eq('percentage--level3')
        end

        it 'percentage between 80 and 100: level4' do
          expect(helper.percentage_class(90)).to eq('percentage--level4')
        end

        it 'percentage is 100%: level5' do
          expect(helper.percentage_class(100)).to eq('percentage--level5')
        end

        it 'blanck in case of invalid percentage' do
          expect(helper.percentage_class(-1)).to be_blank
          expect(helper.percentage_class(nil)).to be_blank
        end
      end


    end
  end
end