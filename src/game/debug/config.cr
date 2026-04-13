require "../window"
require "../core/core"

module Debug
  struct Config
    getter box : Core::Geometry::Box
    getter style : Core::Style

    delegate start_x, start_y, to: box

    def initialize(
      @box : Core::Geometry::Box = Core::Geometry::Box.new(
        position: Core::Geometry::Location.new(x: 1500_f32, y: 50_f32)
      ),
      @style : Core::Style = Core::Style.new,
    )
    end

    def line_height
      style.font_size + box.margin_top
    end
  end
end
