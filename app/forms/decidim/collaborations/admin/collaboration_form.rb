# frozen_string_literal: true

module Decidim
  module Collaborations
    module Admin
      # This class holds a Form to create/update collaborations from
      # Decidim's admin panel.
      class CollaborationForm < Decidim::Form
        include TranslatableAttributes
        include TranslationsHelper

        translatable_attribute :title, String
        translatable_attribute :description, String

        attribute :default_amount, Integer
        attribute :minimum_custom_amount, Integer
        attribute :target_amount, Integer
        attribute :active_until, Date
        attribute :amounts, String

        validates :title, translatable_presence: true
        validates :description, translatable_presence: true
        validates :amounts, presence: true

        validates :default_amount,
                  presence: true,
                  numericality: { only_integer: true, greater_than: 0 }

        validates :minimum_custom_amount,
                  presence: true,
                  numericality: { only_integer: true, greater_than: 0 }

        validates :target_amount,
                  presence: false,
                  numericality: { only_integer: true, greater_than: 0 }

        validate :amounts_consistency

        def map_model(collaboration)
          self.amounts = collaboration.amounts.join(', ')
        end

        private

        def amounts_consistency
          unless value_list?(amounts)
            errors.add(
              :amounts,
              I18n.t('collaboration.amounts.invalid_format', scope: 'activemodel.errors')
            )
          end
        end

        def value_list?(value)
          /^\s*\d+\s*(,\s*\d+\s*)*$/.match?(value)
        end
      end
    end
  end
end
