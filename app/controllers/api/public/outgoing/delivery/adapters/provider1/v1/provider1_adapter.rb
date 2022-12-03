module Api
  module Public
    module Outgoing
      module Delivery
        module Adapters
          module Provider1
            module V1
              class Provider1Adapter < Api::Public::Outgoing::Delivery::Adapters::AdapterBase
                # Send Message to the third party
                # Update message.sent_at if successful
                # Handle error conditions
                def send_message(message_uuid)

                end

                def adapter_name
                  'provider1'
                end
              end
            end
          end
        end
      end
    end
  end
end
