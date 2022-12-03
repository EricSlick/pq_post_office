module Api
  module Public
    module Outgoing
      module Delivery
        # Have the assigned adapter send the message
        # See: Controller Api::Public::Outgoing::Delivery::AdapterManager
        class MessageDeliveryJob
          include Sidekiq::Job

          def perform(message_uuid:, adapter: )
            @adapter = adapter.constantize.new
            response = @adapter.send_message(message_uuid)
            handle_response(message_uuid, response)
          rescue StandardError => e
            handle_exception(message_uuid, e)
          end

          private

          def handle_exception(message_uuid, e)
            Rails.logger.error("MessageDeliverJob Failed: message: #{message_uuid} exception: #{e}")
            message = fetch_message(message_uuid)
            message.update(status_info: "Failed to send message to adapter(#{@adapter.adapter_name}): #{e.message}") if message
          end

          def handle_response(message_uuid, response)
            msg = "For message_uuid(#{message_uuid}), adapter(#{@adapter.adapter_name}) responded with #{response}"
            Rails.logger.info("MessageDeliverJob#handle_response: #{msg}")

            case response[:status]
            when 'success'
            when 'failed'
              message = fetch_message(message_uuid)
              message.update!(status_info: "#{@adapter.adapter_name.capitalize} failed with #{response[:code]}. Cause: #{response[:data]}") if message
            else

            end
          end

          def fetch_message(message_uuid)
            message = Message.find_by(uuid: message_uuid)
            Rails.logger.error("MessageDeliverJob: Invalid message_uuid: #{message_uuid} (deleted?)") if !message
            message
          end
        end
      end
    end
  end
end
