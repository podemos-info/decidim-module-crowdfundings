# frozen_string_literal: true

module Decidim
  module Collaborations
    # This module, when injected into a controller, ensures there's an
    # collaboration available and deducts it from the context.
    module NeedsCollaboration
      def self.included(base)
        base.include InstanceMethods

        enhance_controller(base)
      end

      def self.enhance_controller(instance_or_module)
        instance_or_module.class_eval do
          helper_method :collaboration

          helper Decidim::Collaborations::Admin::CollaborationsHelper
          helper Decidim::Collaborations::CollaborationsHelper
          helper Decidim::Collaborations::TotalsHelper
        end
      end

      module InstanceMethods
        # Public: Finds the current collaboration given this controller's
        # context.
        #
        # Returns the current collaboration.
        def collaboration
          @collaboration ||= detect_collaboration
        end

        private

        def detect_collaboration
          request.env['current_collaboration'] ||
            Collaboration.find_by(id: params[:collaboration_id] || params[:id])
        end
      end
    end
  end
end
