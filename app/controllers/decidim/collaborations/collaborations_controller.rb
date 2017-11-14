# frozen_string_literal: true

module Decidim
  module Collaborations
    # Exposes collaborations to users.
    class CollaborationsController < Decidim::Collaborations::ApplicationController
      include FilterResource

      helper_method :collaboration, :collaborations, :random_seed
      helper Decidim::Collaborations::Admin::CollaborationsHelper
      helper Decidim::PaginateHelper

      private

      def collaboration
        @collaboration ||= Collaboration.find(params[:id])
      end

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

    end
  end
end