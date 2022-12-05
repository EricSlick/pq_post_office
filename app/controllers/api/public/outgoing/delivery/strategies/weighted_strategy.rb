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
                  # when an adapter fails, it will try a new adapters. In this case, the adapters may
                  # be missing one or more adapters and so the index here might be outside the range of @adapters
                  # We then want it to not include a nil adapter value in the @weighted_adapters list.
                  @weighted_adapters << @adapters[index] unless @adapters[index].nil?
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
