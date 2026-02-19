module Layers
  class Input < Base
    include Traits::Eventable

    alias Camera2D = CrystalRaylib::Types::Camera2D

    getter mouse_position : Entities::MousePosition
    private getter camera : Camera2D

    def initialize(@camera : Camera2D, @priority = 10)
      @mouse_position = build_mouse_position
    end

    def emit
      current_mouse_position = build_mouse_position
      if !mouse_position.roughly_equals?(current_mouse_position)
        publish_event(build_event(current_mouse_position))
        @mouse_position = current_mouse_position
      end
    end

    private def build_event(current_mouse_position)
      Events::MousePositionChanged.new(previous_position: @mouse_position, new_position: current_mouse_position)
    end

    private def build_mouse_position
      Entities::MousePosition.from_input(CrystalRaylib::Input.mouse_position, camera)
    end
  end
end
