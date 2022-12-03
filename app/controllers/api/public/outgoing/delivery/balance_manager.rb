module Api
  module Public
    module Outgoing
      module Delivery
        class BalanceManager
          STRATEGIES ={
            round_robin: 'RoundRobinStrategy',
            random: 'RandomStrategy'
          }
          STRATEGIES_KLASSES = 'Api::Public::Outgoing::Delivery::Strategies'
          def initialize(adapters:, strategy: STRATEGIES[:random])
            @adapters = adapters
            @strategy = "#{STRATEGIES_KLASSES}::#{strategy}".constantize.new(adapters: @adapters)
          end

          def use_adapter
            @strategy.use_adapter
          end
        end
      end
    end
  end
end