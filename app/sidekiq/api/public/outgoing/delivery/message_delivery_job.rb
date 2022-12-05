module Api
  module Public
    module Outgoing
      module Delivery
        # Have the assigned adapter send the message
        # See: Controller Api::Public::Outgoing::Delivery::AdapterManager
        class MessageDeliveryJob
          include Sidekiq::Job
          sidekiq_options :queue => :default , :retry => 3

          def perform(message_uuid)
            Rails.logger.info()
            message = Message.find_by(uuid: message_uuid)
            if !message
              Rails.logger.info("MessageDeliveryJob#perform message(#{message_uuid}) no longer exists (deleted?). Aborting Job.")
              return
            end
            @adapter = message.adapter.constantize.new
            response = @adapter.send_message(message_uuid)

            handle_response(message_uuid, response)
          rescue StandardError => e
            handle_exception(message_uuid, e)
          end

          private

          def handle_exception(message_uuid, e)
            Rails.logger.error("MessageDeliverJob Failed: message: #{message_uuid} exception: #{e}")
            message = fetch_message(message_uuid)
            message.update(status_info: "Failed to send message to adapter(#{@adapter&.adapter_name}): #{e.message}") if message
          end

          def handle_response(message_uuid, response)
            msg = "For message_uuid(#{message_uuid}), adapter(#{@adapter.adapter_name}) responded with #{response}"
            Rails.logger.info("MessageDeliverJob#handle_response: #{msg}")

            message = fetch_message(message_uuid)

            return if !message

            case response[:status]
            when 'success'
              message.update!(remote_id: response[:data], status: Message::STATUS[:sent])
            when 'failed'
              message.update!(status_info: response[:data])
              if response[:code] == 500
                skip_adapters = message.adapters_tried || []
                skip_adapters << message.adapter
                Api::Public::Outgoing::Delivery::AdapterManager.new.deliver_without(skip_adapters, message)
              end
            else
              Rails.logger.warn("MessageDeliveryJob: response had invalid response status(#{response[:status]}) for adapter(#{@adapter.adapter_name})")
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
