module Api
  module Public
    module Outgoing
      module Delivery
        class MessageDeliveryJob
          include Sidekiq::Job

          def perform(*args)
            # Do something
          end
        end
      end
    end
  end
end
