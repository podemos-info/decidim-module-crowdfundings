# frozen_string_literal: true

module Census
  module API
    # This class represents an Order in Census API
    class Order < CensusAPI
      def create(params)
        response = self.class.post('/api/v1/payments/orders', body: params)

        if response.code == 422
          broadcast(:ko, JSON.parse(response.body, symbolize_names: true))
        else
          broadcast(:ok, JSON.parse(response.body, symbolize_names: true))
        end
      end
    end
  end
end
