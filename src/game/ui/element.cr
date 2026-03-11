abstract class UI::Element
  include Traits::ScreenDrawable

  property x : Int32, y : Int32, width : Int32, height : Int32
  property background_color : CrystalRaylib::Types::Color
  property border_color : CrystalRaylib::Types::Color
  property border_thickness : Float32

  def initialize(
    @x : Int32 = 0,
    @y : Int32 = 0,
    @width : Int32 = 100,
    @height : Int32 = 50,
    @background_color : CrystalRaylib::Types::Color = CrystalRaylib::Colors::DARK_GRAY,
    @border_color : CrystalRaylib::Types::Color = CrystalRaylib::Colors::WHITE,
    @border_thickness : Float32 = 2.0_f32,
  )
  end

  def contains?(mouse_x : Int32, mouse_y : Int32) : Bool
    mouse_x >= x && mouse_x <= x + width &&
      mouse_y >= y && mouse_y <= y + height
  end

  protected def draw_border
    if @border_thickness > 0
      CrystalRaylib::Shapes.draw_rectangle_lines_ex(x, y, width, height, @border_thickness, @border_color)
    end
  end

  abstract def draw : Nil
  abstract def update(mouse_x : Int32, mouse_y : Int32, clicked : Bool) : Nil
end
