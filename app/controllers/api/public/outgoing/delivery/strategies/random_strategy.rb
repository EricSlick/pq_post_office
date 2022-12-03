module Api
  module Public
    module Outgoing
      module Delivery
        module Strategies
          class RandomStrategy
            def initialize(adapters: )
              @adapters = adapters
            end

            def use_adapter
              @adapters[rand(@adapters.length)]
            end
          end
        end
      end
    end
  end
end