module Events
  class MousePositionChanged < Base
    getter previous_position : CrystalRaylib::Types::Vector2
    getter new_position : CrystalRaylib::Types::Vector2

    def initialize(@previous_position, @new_position)
    end
  end
end
