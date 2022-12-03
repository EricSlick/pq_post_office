module Api
  module Public
    module Outgoing
      module Delivery
        class BalanceManager
          STRATEGIES ={
            round_robin: 'RoundRobinStrategy',
            random: 'RandomStrategy'
          }
          DEFAULT_STRATEGY = :random
          STRATEGIES_KLASSES = 'Api::Public::Outgoing::Delivery::Strategies'

          attr_accessor :adapters, :strategy
          attr_reader :strategy_klass

          def initialize(adapters:, strategy: STRATEGIES[DEFAULT_STRATEGY])
            @adapters = adapters
            @strategy = strategy
            @strategy_klass = "#{STRATEGIES_KLASSES}::#{strategy}".constantize.new(adapters: @adapters)
          end

          def use_adapter
            @strategy_klass.use_adapter
          end
        end
      end
    end
  end
end