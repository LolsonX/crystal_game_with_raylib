module Core
  module Geometry
    struct Dimension
      getter width : Float32
      getter height : Float32

      def initialize(@width : Float32, @height : Float32)
      end
    end
  end
end
