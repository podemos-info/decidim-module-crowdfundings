# frozen_string_literal: true

module Decidim
  module Collaborations
    module Admin
      # This command is executed when the user creates a Collaboration from
      # the admin panel.
      class CreateCollaboration < Rectify::Command
        def initialize(form)
          @form = form
        end

        # Creates the project if valid.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          return broadcast(:invalid) if @form.invalid?
          create_collaboration
          broadcast(:ok)
        end

        private

        def create_collaboration
          Collaboration.create(
            feature: @form.current_feature,
            title: @form.title,
            description: @form.description,
            default_amount: @form.default_amount,
            minimum_custom_amount: @form.minimum_custom_amount,
            target_amount: @form.target_amount,
            active_until: @form.active_until
          )
        end
      end
    end
  end
end
