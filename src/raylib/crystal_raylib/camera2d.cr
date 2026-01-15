module CrystalRaylib
  module Camera2D
    def self.begin_mode_2d(camera : Types::Camera2D)
      LibRaylib.begin_mode_2d(camera.to_lib)
    end

    def self.end_mode_2d
      LibRaylib.end_mode_2d
    end

    def self.screen_to_world_2d(vector : Types::Vector2, camera : Types::Camera2D) : Types::Vector2
      Types::Vector2.from_lib(LibRaylib.get_screen_to_world_2d(vector.to_lib, camera.to_lib))
    end

    def self.with_mode_2d(camera : Types::Camera2D, &)
      LibRaylib.begin_mode_2d(camera.to_lib)
      yield
      LibRaylib.end_mode_2d
    end

    def self.world_to_screen_2d(vector : Types::Vector2, camera : Types::Camera2D) : Types::Vector2
      Types::Vector2.from_lib(LibRaylib.get_world_to_screen_2d(vector.to_lib, camera.to_lib))
    end
  end
end
