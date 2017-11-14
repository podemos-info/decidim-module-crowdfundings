# frozen_string_literal: true

require 'rails'
require 'active_support/all'

require 'decidim/core'

module Decidim
  module Collaborations
    # Decidim's Collaborations Rails Engine.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Collaborations

      routes do
        resources :collaborations, only: %i[index show]
        root to: 'collaborations#index'
      end

      initializer 'decidim_collaborations.inject_abilities_to_user' do |_app|
        Decidim.configure do |config|
          config.abilities += %w[
            Decidim::Collaborations::Abilities::CurrentUserAbility
          ]
        end
      end

      initializer 'decidim_collaborations.assets' do |app|
        app.config.assets.precompile += %w[decidim_collaborations_manifest.js]
      end
    end
  end
end
