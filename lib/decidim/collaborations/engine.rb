# frozen_string_literal: true

require 'rails'
require 'active_support/all'
require 'decidim/core'
# require 'decidim/colllaborations/user_profile_engine'

module Decidim
  module Collaborations
    # Decidim's Collaborations Rails Engine.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Collaborations

      # TODO: Repace this by global routes feature that will be released in decidim 0.8.1
      initializer "decidim_collaborations_user_profile.mount_routes" do |_app|
        Decidim::Core::Engine.routes do
          mount Decidim::Collaborations::UserProfileEngine => '/collaborations'
        end
      end

      routes do
        resources :collaborations, only: %i[index show] do
          resources :user_collaborations, only: %i[create], shallow: true do
            collection do
              post :confirm
            end
            member do
              get :validate
            end
          end
        end

        root to: 'collaborations#index'
      end

      initializer 'decidim_collaborations.inject_abilities_to_user' do |_app|
        Decidim.configure do |config|
          config.abilities += %w[
            Decidim::Collaborations::Abilities::CurrentUserAbility
            Decidim::Collaborations::Abilities::GuestUserAbility
          ]
        end
      end

      initializer 'decidim_collaborations.assets' do |app|
        app.config.assets.precompile += %w[decidim_collaborations_manifest.js]
      end
    end
  end
end
