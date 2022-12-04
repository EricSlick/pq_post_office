require 'faraday'

module Api
  module Public
    module Outgoing
      module Delivery
        module Adapters
          class AdapterBase < ApplicationController
            include Rails.application.routes.url_helpers

            skip_before_action :verify_authenticity_token, only: [:delivery_status_callback]

            def message_callback(message_uuid)
              message = Message.find_by(uuid: message_uuid)
              message.update(delivered_at: DateTime.current)
              Rails.logger.info("Message #{message_uuid} reported as delivered by #{adapter_name}")
            end

            def send_message(message_uuid)
              raise ImplementMethod 'Child Class must implement #send_message'
            end

            def delivery_status_callback
              raise ImplementMethod 'Child Class must implement #delivery_status_callback'
            end

            def adapter_name
              raise ImplementMethod 'Child Class must implement #adapter_name'
            end

            private

            def build_response
              raise ImplementMethod 'Child Class must implement private #build_response'
            end

            def callback_url
              if Rails.env.production?
                "https://pq-post-office.onrender.com#{delivery_status_callback_api_public_outgoing_delivery_adapters_provider1_v1_provider1_adapters_path}"
              elsif Rails.env.development?
                "https://63a6-38-44-145-216.ngrok.io#{delivery_status_callback_api_public_outgoing_delivery_adapters_provider1_v1_provider1_adapters_path}"
              else
                "https://63a6-38-44-145-216.ngrok.io/api/public/outgoing/delivery/adapters/provider1/v1/provider1_adapters/delivery_status_callback"
              end
            end
          end
        end
      end
    end
  end
end
