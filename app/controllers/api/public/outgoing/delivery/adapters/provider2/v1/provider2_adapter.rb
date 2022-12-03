
module Api
module Public
  module Outgoing
    module Delivery
      module Adapters
        module Provider2
          module V1
            class Provider2Adapter
              # Send Message to the third party
              # Update message.sent_at if successful
              # Handle error conditions
              def send_message(message_uuid)

              end

              def adapter_name
                'provider2'
              end
            end
          end
        end
      end
    end
  end
end
end