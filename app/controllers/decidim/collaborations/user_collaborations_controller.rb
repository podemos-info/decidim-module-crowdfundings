# frozen_string_literal: true

module Decidim
  module Collaborations
    # Controller responsible of managing user collaborations
    class UserCollaborationsController < Decidim::Collaborations::ApplicationController
      include NeedsCollaboration
      include CensusAPI

      def confirm
        @form = collaboration_form
               .from_params(params, collaboration: collaboration)

        if @form.valid?
          @form = confirmed_collaboration_form
                  .from_params(params, collaboration: collaboration)
          @form.correct_payment_method
        else
          render '/decidim/collaborations/collaborations/show'
        end
      end

      private

      def collaboration_form
        form(Decidim::Collaborations::UserCollaborationForm)
      end

      def confirmed_collaboration_form
        form(Decidim::Collaborations::ConfirmUserCollaborationForm)
      end
    end
  end
end
