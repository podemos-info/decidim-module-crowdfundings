# frozen_string_literal: true
require 'httparty'

module Census
  module API
    # Base class for all Census API classes
    class CensusAPI
      include ::HTTParty
      include ::Wisper::Publisher

      base_uri ::Decidim::Collaborations.census_api_base_uri
    end
  end
end
