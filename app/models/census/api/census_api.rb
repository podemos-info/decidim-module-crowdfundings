# frozen_string_literal: true
require 'httparty'

module Census
  module API
    # Base class for all Census API classes
    class CensusAPI
      include ::HTTParty
      include ::Wisper::Publisher

      base_uri ::Decidim::Collaborations.census_api_base_uri

      unless Decidim::Collaborations.census_api_proxy_address.blank?
        http_proxy Decidim::Collaborations.census_api_proxy_address, Decidim::Collaborations.census_api_proxy_port
      end

      debug_output if Decidim::Collaborations.census_api_debug
    end
  end
end
