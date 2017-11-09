# frozen_string_literal: true

module Decidim
  module Collaborations
    # Exposes collaborations to users.
    class CollaborationsController < Decidim::Collaborations::ApplicationController
      helper_method :collaboration

      private

      def collaboration
        @collaboration ||= Collaboration.find(params[:id])
      end
    end
  end
end