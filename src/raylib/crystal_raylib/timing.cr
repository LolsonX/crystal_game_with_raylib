module CrystalRaylib
  module Timing
    def self.frame_time : Float32
      LibRaylib.frame_time
    end

    def self.target_fps=(fps : Int32)
      LibRaylib.set_target_fps(fps)
    end
  end
end
