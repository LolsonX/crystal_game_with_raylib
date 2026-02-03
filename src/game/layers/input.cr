module Layers
  class Input < Base
    include Traits::Eventable

    getter mouse_position : CrystalRaylib::Types::Vector2

    def initialize(@priority = 10)
      @mouse_position = CrystalRaylib::Input.mouse_position
    end

    def emit
      current_mouse_position = CrystalRaylib::Input.mouse_position
      if !mouse_position.roughly_equals?(current_mouse_position)
        publish_event(build_event(current_mouse_position))
        @mouse_position = current_mouse_position
      end
    end

    private def build_event(current_mouse_position)
      Events::MousePositionChanged.new(previous_position: @mouse_position, new_position: current_mouse_position)
    end
  end
end
