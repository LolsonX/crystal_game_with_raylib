module Events
  class MousePositionChanged < Base
    getter previous_position : Entities::MousePosition
    getter new_position : Entities::MousePosition

    def initialize(@previous_position, @new_position)
    end
  end
end
