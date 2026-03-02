module Layers
  class Input < Base
    include Traits::Eventable

    alias Camera2D = CrystalRaylib::Types::Camera2D

    getter mouse_position : Entities::MousePosition
    private getter camera : Camera2D

    def initialize(@camera : Camera2D, @priority = 20)
      @mouse_position = build_mouse_position
    end

    def emit
      emit_mouse_position_changed
      emit_mouse_wheel_moved
    end

    private def emit_mouse_position_changed
      current_mouse_position = build_mouse_position
      if !mouse_position.roughly_equals?(current_mouse_position)
        publish_event(build_mouse_moved_event(current_mouse_position))
        @mouse_position = current_mouse_position
      end
    end

    private def emit_mouse_wheel_moved
      mouse_movement = detect_mouse_wheel_movement
      return if mouse_movement.zero?

      publish_event(build_mouse_wheel_moved_event(mouse_movement))
    end

    private def build_mouse_moved_event(current_mouse_position)
      Events::MousePositionChanged.new(previous_position: @mouse_position, new_position: current_mouse_position)
    end

    private def build_mouse_position
      Entities::MousePosition.from_input(CrystalRaylib::Input.mouse_position, camera)
    end

    private def detect_mouse_wheel_movement
      CrystalRaylib::Input.mouse_wheel_movement
    end

    private def build_mouse_wheel_moved_event(mouse_movement)
      Events::MouseWheelMoved.build_from(mouse_movement)
    end
  end
end
