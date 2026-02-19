module Entities
  class MousePosition
    alias Camera2D = CrystalRaylib::Types::Camera2D
    alias Vector2 = CrystalRaylib::Types::Vector2

    EPSILON = 0.001_f32

    getter screen_position : Vector2
    getter world_position : Vector2
    getter camera : Camera2D

    def initialize(@screen_position, @world_position, @camera)
    end

    def roughly_equals?(other : MousePosition) : Bool
      (world_x - other.world_x).abs < EPSILON && (world_y - other.world_y).abs < EPSILON
    end

    def world_x
      world_position.x
    end

    def world_y
      world_position.y
    end

    def screen_x
      screen_position.x
    end

    def screen_y
      screen_position.y
    end

    def self.from_input(mouse_position : Vector2, camera : Camera2D)
      world_position = CrystalRaylib::Camera2D.screen_to_world_2d(vector: mouse_position, camera: camera)
      new(screen_position: mouse_position, world_position: world_position, camera: camera)
    end
  end
end
