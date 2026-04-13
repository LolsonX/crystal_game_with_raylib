module Core
  module Geometry
    struct Location
      getter x : Float32
      getter y : Float32

      def initialize(@x : Float32, @y : Float32)
      end
    end
  end
end
