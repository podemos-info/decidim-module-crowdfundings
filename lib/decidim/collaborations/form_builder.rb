# frozen_string_literal

module Decidim
  module Collaborations
    # Extends Decidim's Form builder to add a form input for collaborations.
    class ::Decidim::FormBuilder
      include ::ActionView::Helpers::FormTagHelper
      include ::ActionView::Helpers::NumberHelper

      def donate_tag(name, amounts)
        amount_selector_tag(name, amounts) + amount_input_tag(name)
      end

      private

      def amount_selector_tag(name, amounts)
        content_tag :div, class: 'amount-selector' do
          amounts.each do |amount|
            concat(input_amount_for(name, amount))
          end

          concat(input_other_amounts(name, amounts))
        end
      end

      def input_other_amounts(name, amounts)
        amount = object.send(name)
        checked = !amount.blank? && !amounts.include?(amount)

        content_tag :label do
          concat radio_button_tag "#{name}_selector".to_sym, 'other', checked
          concat amount_label(I18n.t('donate_tag.other', scope: 'decidim.form_builder'))
        end
      end

      def input_amount_for(name, amount)
        checked = object.send(name) == amount

        content_tag :label do
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

      def amount_input_tag(name)
        content_tag :div, class: 'field' do
          number_field name, min: 0, step: 5
        end
      end
    end
  end
end