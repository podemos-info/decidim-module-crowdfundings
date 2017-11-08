# frozen_string_literal: true

require 'decidim/collaborations/engine'
require 'decidim/collaborations/admin'
require 'decidim/collaborations/admin_engine'
require 'decidim/collaborations/feature'

module Decidim
  # Base module for this engine.
  module Collaborations
    include ActiveSupport::Configurable

    # Public setting that defines the maximum annual collaboration
    # for an user.
    config_accessor :maximum_annual_collaboration do
      10_000
    end

    # Ammounts offered to the user for collaborating with a
    # participatory space.
    config_accessor :selectable_amounts do
      [25, 50, 100, 250, 500]
    end
  end
end
