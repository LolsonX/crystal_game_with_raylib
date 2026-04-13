abstract class UI::Element
  include Traits::ScreenDrawable

  property location : Core::Geometry::Location
  property dimension : Core::Geometry::Dimension
  property style : Core::Styles::Element

  delegate(x, y, to: location)
  delegate(width, height, to: dimension)

  def initialize(
    @location : Core::Geometry::Location = Core::Geometry::Location.new(x: 0.0_f32, y: 0.0_f32),
    @dimension : Core::Geometry::Dimension = Core::Geometry::Dimension.new(width: 100.0_f32, height: 50.0_f32),
    @style : Core::Styles::Element = Core::Styles::Element.new,
  )
  end

  def contains?(mouse_x : Float32, mouse_y : Float32) : Bool
    mouse_x >= x + style.border_thickness && mouse_x <= x + width - style.border_thickness &&
      mouse_y >= y + style.border_thickness && mouse_y <= y + height - style.border_thickness
  end

  protected def draw_border
    if style.border_thickness > 0
      CrystalRaylib::Shapes.draw_rectangle_lines_ex(
        x.to_i32, y.to_i32, width.to_i32, height.to_i32,
        style.border_thickness, style.border_color
      )
    end
  end

  abstract def draw : Nil
  abstract def update(mouse_x : Int32, mouse_y : Int32, clicked : Bool) : Nil
end
