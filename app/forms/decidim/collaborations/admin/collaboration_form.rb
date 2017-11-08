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
        attribute :maximum_authorized_amount, Integer
        attribute :target_amount, Integer
        attribute :active_until, Date

        validates :title, translatable_presence: true
        validates :description, translatable_presence: true

        validates :default_amount,
                  presence: true,
                  numericality: { only_integer: true, greater_than: 0 }

        validates :maximum_authorized_amount,
                  presence: true,
                  numericality: { only_integer: true, greater_than: 0 }

        validates :target_amount,
                  presence: false,
                  numericality: { only_integer: true, greater_than: 0 }
      end
    end
  end
end
