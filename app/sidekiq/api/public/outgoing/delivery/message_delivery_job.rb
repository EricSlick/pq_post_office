module Api
  module Public
    module Outgoing
      module Delivery
        # Have the assigned adapter send the message
        # See: Controller Api::Public::Outgoing::Delivery::AdapterManager
        class MessageDeliveryJob
          include Sidekiq::Job

          def perform(message_uuid:, adapter: )
            adapter.constantize.new.send_message(message_uuid)
          rescue StandardError => e
            Rails.logger.error("MessageDeliverJob Failed: #{e.message}")
            raise # allow for unhandled error catch
          end
        end
      end
    end
  end
end
