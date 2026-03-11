module CrystalRaylib
  module Input
    LEFT_BUTTON = 0

    def self.key_down?(key_code : Int32) : Bool
      LibRaylib.key_down?(key_code)
    end

    def self.pressed_key : Int32
      LibRaylib.key_pressed
    end

    def self.mouse_position : Types::Vector2
      Types::Vector2.from_lib LibRaylib.mouse_position
    end

    def self.mouse_wheel_movement : Float32
      LibRaylib.mouse_wheel_movement
    end

    def self.mouse_button_pressed?(button : Int32) : Bool
      LibRaylib.mouse_button_pressed(button)
    end

    def self.mouse_button_down?(button : Int32) : Bool
      LibRaylib.mouse_button_down(button)
    end
  end
end
