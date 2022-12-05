module Api
  module Public
    module Outgoing
      module Delivery
        module Strategies
          class WeightedStrategy
            attr_reader :weighted_adapters
            # weights = [3, 7] (ordered by list of @adapters. If missing a weight, it is treated as 1)
            def initialize(adapters: , weights: [3, 7] )
              @adapters = adapters
              @weighted_adapters = []
              weights.each_with_index do | weight,index|
                (1..weight).each do
                  @weighted_adapters << @adapters[index]
                end
              end
            end

            def use_adapter
              @weighted_adapters[rand(@weighted_adapters.length)]
            end
          end
        end
      end
    end
  end
end
