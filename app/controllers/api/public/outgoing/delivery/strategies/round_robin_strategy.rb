module Api
  module Public
    module Outgoing
      module Delivery
        module Strategies
          class RoundRobinStrategy
            def initialize(adapters: )
              @adapters = adapters
              @strategy = Strategy.create_or_find_by(name: 'round_robin')
            end

            def use_adapter
              strategy_data = @strategy.data || {}
              last_adapter = strategy_data['last_adapter']
              next_adapter = last_adapter ? last_adapter + 1 : 0
              next_adapter = 0 if next_adapter >= @adapters.length
              @strategy.update(data: {last_adapter: next_adapter})
              @adapters[next_adapter]
            end
          end
        end
      end
    end
  end
end