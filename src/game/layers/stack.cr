module Layers
  class Stack
    getter layers : Array(Layers::Base)

    def initialize
      @layers = [] of Layers::Base
    end

    def push(layer : Layers::Base)
      @layers.tap &.push(layer)
        .sort { |stacked_layer| -stacked_layer.priority }
    end

    def layers_with_trait(tait : T.class) forall T
      @layers.select(T)
        .map(&.as(T))
    end

    def each_with_trait(trait : T.class, &) forall T
      layers_with_trait(T).each { |layer| yield layer }
    end
  end
end
