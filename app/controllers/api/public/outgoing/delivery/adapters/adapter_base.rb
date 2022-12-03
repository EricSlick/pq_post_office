module Api
  module Public
    module Outgoing
      module Delivery
        module Adapters
          class AdapterBase < ApplicationController

            def message_callback(message_uuid)
              message = Message.find_by(uuid: message_uuid)
              message.update(delivered_at: DateTime.current)
              Rails.logger.info("Message #{message_uuid} reported as delivered by #{adapter_name}")
            end

            def send_message(message_uuid)
              raise ImplementMethod 'Child Class must implement #send_message'
            end

            def adapter_name
              raise ImplementMethod 'Child Class must implement #adapter_name'
            end
          end
        end
      end
    end
  end
end
