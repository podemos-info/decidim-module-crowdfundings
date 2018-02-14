# frozen_string_literal: true

module Decidim
  module Collaborations
    # Rectify command that creates a user collaboration
    class UpdateUserCollaboration < Rectify::Command
      attr_reader :form

      def initialize(form)
        @form = form
      end

      # Updates the user collaboration if valid.
      #
      # Broadcasts :ok if successful, :invalid otherwise.
      def call
        return broadcast(:invalid) if form.invalid?
        begin
          form.context.user_collaboration.update!(form.attributes)
          broadcast(:ok)
        rescue StandardError => e
          broadcast(:invalid, e)
        end
      end
    end
  end
end
