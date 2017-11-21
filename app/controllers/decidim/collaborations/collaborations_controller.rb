# frozen_string_literal: true

module Decidim
  module Collaborations
    # Exposes collaborations to users.
    class CollaborationsController < Decidim::Collaborations::ApplicationController
      include FilterResource

      helper_method :collaboration, :collaborations, :random_seed
      helper Decidim::Collaborations::Admin::CollaborationsHelper
      helper Decidim::Collaborations::TotalsHelper
      helper Decidim::PaginateHelper

      def index
        return unless feature_collaborations.count == 1

        redirect_to collaboration_path(
          feature_id: params[:feature_id],
          participatory_process_slug: params[:participatory_process_slug],
          id: feature_collaborations.first.id
        )
      end

      def show
        @form = user_collaboration_form.instance
        @form.amount = collaboration.default_amount
      end

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

      def feature_collaborations
        Collaboration.for_feature(current_feature)
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