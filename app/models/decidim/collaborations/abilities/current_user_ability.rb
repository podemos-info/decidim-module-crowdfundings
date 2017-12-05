# frozen_string_literal: true

module Decidim
  module Collaborations
    module Abilities
      # CanCanCan abilities related to current user.
      class CurrentUserAbility
        include CanCan::Ability

        attr_reader :user, :context

        def initialize(user, context)
          return unless user

          @user = user
          @context = context

          can :support, Collaboration do |collaboration|
            collaboration.accepts_supports? &&
              current_settings.collaborations_allowed? &&
              Census::API::Totals.user_totals(user.id) < Decidim::Collaborations.maximum_annual_collaboration
          end

          can :support_recurrently, Collaboration do |collaboration|
            collaboration.recurrent_support_allowed? &&
              collaboration.user_collaborations.supported_by(user).none?
          end
        end

        private

        def current_settings
          @context.fetch(:current_settings, nil)
        end
      end
    end
  end
end