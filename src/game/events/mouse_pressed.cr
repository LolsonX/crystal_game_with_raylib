module Events
  class MousePressed < Base
    getter screen_x : Int32
    getter screen_y : Int32
    getter world_x : Float32
    getter world_y : Float32

    def initialize(@screen_x : Int32, @screen_y : Int32, @world_x : Float32, @world_y : Float32)
    end
  end
end
