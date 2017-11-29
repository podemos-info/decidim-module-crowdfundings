module Decidim
  module Collaborations
    # Rectify command that creates a user collaboration
    class CreateUserCollaboration < Rectify::Command
      include Decidim::TranslationsHelper

      attr_reader :form

      def initialize(form)
        @form = form
      end

      # Creates the user collaboration if valid.
      #
      # Broadcasts :ok if successful, :invalid otherwise.
      def call
        return broadcast(:invalid) if form.invalid?
        census_result = process_user_collaboration
        case census_result[:http_response_code]
        when 201
          broadcast(:ok)
        when 202
          broadcast(:credit_card, census_result)
        else
          broadcast(:invalid)
        end
      end

      private

      def process_user_collaboration
        result = register_on_census
        if result[:http_response_code].between?(201, 202)
          create_user_collaboration result[:payment_method_id]
        end

        result
      end

      def register_on_census
        Census::API::Order.create(census_parameters)
      end

      def census_parameters
        params = {
          person_id: form.context.current_user.id,
          description: translated_attribute(form.context.collaboration.title),
          amount: form.amount * 100,
          campaign_code: form.context.collaboration.id,
          payment_method_type: form.payment_method_type,
        }

        if form.credit_card_external?
          params[:return_url] = validate_user_collaboration_url(
            form.context.collaboration, result: '__RESULT__'
          )
        end

        if form.existing_payment_method?
          params[:payment_method_id] = form.payment_method_id
        end

        params[:iban] = form.iban if form.direct_debit?
        params
      end

      def create_user_collaboration(payment_method_id = nil)
        UserCollaboration.create(
          collaboration: form.context.collaboration,
          user: form.context.current_user,
          frequency: form.frequency,
          amount: form.amount,
          payment_method_id: payment_method_id || form.payment_method_id,
          state: collaboration_state,
          last_order_request_date: Date.today.beginning_of_month
        )
      end

      def collaboration_state
        return 'pending' if form.credit_card_external?
        'accepted'
      end
    end
  end
end
