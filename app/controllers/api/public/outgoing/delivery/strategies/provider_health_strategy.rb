module Api
  module Public
    module Outgoing
      module Delivery
        module Strategies
          class ProviderHealthStrategy
            def initialize(adapters: )
              @adapters = adapters
            end

            def use_adapter
              # check on the health of each adapter
              # weight according to health
              # call the weighted strategy to pick the adapter
              # probably need to optimize for this strategy but using existing messages dat
              #   pull the last x number of messages sent to each adapter
              #   check for status and weight accordingly
            end
          end
        end
      end
    end
  end
end