module Layers
  class Stack
    getter layers : Array(Layers::Base)

    def initialize
      @layers = [] of Layers::Base
    end

    def push(layer : Layers::Base)
      @layers.push(layer)
      @layers.sort! { |layer_a, layer_b| layer_a.priority <=> layer_b.priority }
    end

    def layers_with_trait(trait : T.class) forall T
      @layers.select(T)
        .map(&.as(T))
    end

    def each_with_trait(trait : T.class, &) forall T
      layers_with_trait(T).each { |layer| yield layer }
    end

    def each_with_trait_unblocked(trait : T.class, &) forall T
      layers_with_trait(T).each do |layer|
        next if layer.blocked?
        yield layer
      end
    end

    def block_below_priority(priority : Int32)
      @layers.each do |layer|
        layer.blocked = true if layer.priority < priority
      end
    end

    def unblock_all
      @layers.each(&.blocked = false)
    end
  end
end
