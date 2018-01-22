# frozen_string_literal

module Decidim
  module Collaborations
    # Extends Decidim's Form builder to add a form input for collaborations.
    class ::Decidim::FormBuilder
      include ::ActionView::Helpers::FormTagHelper
      include ::ActionView::Helpers::NumberHelper

      def support_tag(name, amounts, minimum)
        amount_selector_tag(name, amounts, minimum)
      end

      private

      def amount_selector_tag(name, amounts, minimum)
        content_tag :div, class: 'amount-selector' do
          amounts.each do |amount|
            concat(input_amount_for(name, amount))
          end

          concat(input_other_amounts(name, amounts))
          concat(amount_input_tag(name, minimum))
        end
      end

      def input_other_amounts(name, amounts)
        amount = object.send(name)
        checked = !amount.blank? && !amounts.include?(amount)

        content_tag :label, for: "#{name}_selector_other" do
          concat radio_button_tag "#{name}_selector".to_sym, 'other', checked
          concat amount_label(I18n.t('support_tag.other', scope: 'decidim.form_builder'))
        end
      end

      def input_amount_for(name, amount)
        checked = object.send(name) == amount

        content_tag :label, for: "#{name}_selector_#{amount}" do
          concat radio_button_tag "#{name}_selector".to_sym, amount, checked
          concat amount_label(amount)
        end
      end

      def amount_label(amount)
        content_tag :div do
          if amount.is_a? Integer
            number_to_currency(amount,
                               unit: Decidim.currency_unit,
                               precision: 0,
                               format: '%n %u')
          else
            amount
          end
        end
      end

      def amount_input_tag(name, minimum)
        content_tag :div, class: 'field' do
          number_field name, min: minimum, step: 5
        end
      end
    end
  end
end
