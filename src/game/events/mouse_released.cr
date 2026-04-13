module Events
  class MouseReleased < Base
    getter screen_x : Int32
    getter screen_y : Int32

    def initialize(@screen_x : Int32, @screen_y : Int32)
    end
  end
end
