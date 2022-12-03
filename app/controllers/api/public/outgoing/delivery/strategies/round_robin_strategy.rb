module Api
  module Public
    module Outgoing
      module Delivery
        module Strategies
          class RoundRobinStrategy
            def initialize(adapters: )
              @adapters = adapters
            end

            def use_adapter

            end
          end
        end
      end
    end
  end
end