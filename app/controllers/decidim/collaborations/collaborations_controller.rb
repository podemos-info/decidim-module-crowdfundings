# frozen_string_literal: true

module Decidim
  module Collaborations
    # Exposes collaborations to users.
    class CollaborationsController < Decidim::Collaborations::ApplicationController
      include FilterResource

      helper_method :collaborations, :random_seed
      helper Decidim::PaginateHelper
      helper Decidim::ParticipatoryProcesses::ParticipatoryProcessHelper

      include NeedsCollaboration

      def show
        @form = user_collaboration_form.instance(collaboration: collaboration)
        @form.amount = collaboration.default_amount
        @form.frequency = 'punctual'
      end

      private

      def collaborations
        @collaborations ||= search
                              .results
                              .page(params[:page])
                              .per(Decidim::Collaborations.collaborations_shown_per_page)
      end

      def random_seed
        @random_seed ||= search.random_seed
      end

      def search_klass
        CollaborationSearch
      end

      def default_filter_params
        {
          search_text: '',
          random_seed: params[:random_seed]
        }
      end

      def context_params
        { feature: current_feature, organization: current_organization }
      end

      def user_collaboration_form
        form(Decidim::Collaborations::UserCollaborationForm)
      end
    end
  end
end