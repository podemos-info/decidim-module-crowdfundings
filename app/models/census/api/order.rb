# frozen_string_literal: true

module Census
  module API
    # This class represents an Order in Census API
    class Order < CensusAPI
      def self.create(params)
        response = post("/api/v1/payments/orders", body: params)

        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:http_response_code] = response.code.to_i

        json_response
      rescue StandardError => e
        Rails.logger.debug "Request to /api/v1/payments/payment_methods failed with code #{e.response.code}: #{e.response.message}"
        { http_response_code: e.response.code.to_i, message: e.response.message }
      end
    end
  end
end
