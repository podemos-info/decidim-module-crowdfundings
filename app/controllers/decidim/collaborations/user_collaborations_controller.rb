# frozen_string_literal: true

module Decidim
  module Collaborations
    class UserCollaborationsController < Decidim::Collaborations::ApplicationController
      include NeedsCollaboration

      def confirm
        @form = collaboration_form.from_params(params, collaboration: collaboration)
      end

      private

      # def context_params
      #   { feature: current_feature, organization: current_organization }
      # end

      def collaboration_form
        form(Decidim::Collaborations::ConfirmUserCollaborationForm)
      end
    end
  end
end
