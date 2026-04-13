module Core
  module Geometry
    struct Box
      getter position : Location
      getter dimension : Dimension
      getter padding_top : Int32
      getter padding_left : Int32
      getter margin_top : Int32
      getter box_padding : Int32
      getter spacing : Int32

      def initialize(
        @position : Location = Location.new(x: 0.0_f32, y: 0.0_f32),
        @dimension : Dimension = Dimension.new(width: 420.0_f32, height: 900.0_f32),
        @padding_top : Int32 = 5,
        @padding_left : Int32 = 5,
        @margin_top : Int32 = 30,
        @box_padding : Int32 = 10,
        @spacing : Int32 = 10,
      )
      end

      def start_x : Int32
        position.x.to_i + box_padding + padding_left
      end

      def start_y : Int32
        position.y.to_i + box_padding + padding_top
      end
    end
  end
end
