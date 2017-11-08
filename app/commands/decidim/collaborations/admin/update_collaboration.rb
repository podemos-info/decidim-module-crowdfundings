# frozen_string_literal: true

module Decidim
  module Collaborations
    module Admin
      # This command is executed when the user changes a Collaboration from
      # the admin panel.
      class UpdateCollaboration < Rectify::Command
        # Initializes an UpdateProject Command.
        #
        # form - The form from which to get the data.
        # collaboration - The current instance of the collaboration to be updated.
        def initialize(form, collaboration)
          @form = form
          @collaboration = collaboration
        end

        # Updates the collaboration if valid.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          return broadcast(:invalid) if form.invalid?

          update_collaboration
          broadcast(:ok)
        end

        private

        attr_reader :collaboration, :form

        def update_collaboration
          collaboration.update_attributes!(
            title: form.title,
            description: form.description,
            default_amount: @form.default_amount,
            maximum_authorized_amount: @form.maximum_authorized_amount,
            target_amount: @form.target_amount,
            active_until: @form.active_until
          )
        end
      end
    end
  end
end
