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
          helper_method :support_status_message

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

        # Public: Returns the reason why collaboration is not allowed.
        def support_status_message
          if maximum_per_year_reached?
            return I18n.t 'decidim.collaborations.labels.support_status.maximum_annual_exceeded'
          end

          if target_amount_reached?
            return I18n.t 'decidim.collaborations.labels.support_status.objective_reached'
          end

          if out_of_collaboration_period?
            return I18n.t 'decidim.collaborations.labels.support_status.support_period_finished'
          end

          I18n.t 'decidim.collaborations.labels.support_status.collaboration_not_allowed'
        end

        private

        def target_amount_reached?
          collaboration.percentage && collaboration.percentage >= 100.0
        end

        def maximum_per_year_reached?
          user_totals = Census::API::Totals.user_totals(current_user.id)
          user_totals && user_totals >= Decidim::Collaborations.maximum_annual_collaboration
        end

        def out_of_collaboration_period?
          collaboration.active_until && collaboration.active_until < Date.today
        end

        def detect_collaboration
          request.env['current_collaboration'] ||
            Collaboration.find_by(id: params[:collaboration_id] || params[:id])
        end
      end
    end
  end
end
