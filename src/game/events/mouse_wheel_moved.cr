module Events
  class MouseWheelMoved < Base
    enum ScrollDirection : Int32
      Down = -1
      None =  0
      Up   =  1
    end

    getter mouse_movement : ScrollDirection

    def initialize(@mouse_movement : ScrollDirection)
    end

    def self.build_from(movement : Float32)
      new(mouse_movement: ScrollDirection.new(movement.to_i32))
    end
  end
end
