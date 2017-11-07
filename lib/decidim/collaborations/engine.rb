# frozen_string_literal: true

require 'rails'
require 'active_support/all'

require 'decidim/core'

module Decidim
  module Collaborations
    # Decidim's Collaborations Rails Engine.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Collaborations

      initializer 'decidim_collaborations.assets' do |app|
        app.config.assets.precompile += %w(decidim_collaborations_manifest.js)
      end
    end
  end
end
