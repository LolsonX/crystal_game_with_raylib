class UI::Button < UI::Element
  include Traits::Clickable

  property hover_color : CrystalRaylib::Types::Color
  property pressed_color : CrystalRaylib::Types::Color

  def initialize(
    x : Int32 = 0,
    y : Int32 = 0,
    width : Int32 = 120,
    height : Int32 = 40,
    background_color : CrystalRaylib::Types::Color = CrystalRaylib::Colors::DARK_GRAY,
    @hover_color : CrystalRaylib::Types::Color = CrystalRaylib::Colors::GRAY,
    @pressed_color : CrystalRaylib::Types::Color = CrystalRaylib::Colors::SKY_BLUE,
    border_color : CrystalRaylib::Types::Color = CrystalRaylib::Colors::WHITE,
    border_thickness : Float32 = 2.0_f32,
  )
    super(x, y, width, height, background_color, border_color, border_thickness)
    @state = :normal
  end

  def draw : Nil
    color = case @state
            when :hover   then @hover_color
            when :pressed then @pressed_color
            else               @background_color
            end

    CrystalRaylib::Shapes.draw_rectangle(x, y, width, height, color)
    if @border_thickness > 0
      CrystalRaylib::Shapes.draw_rectangle_lines_ex(x, y, width, height, @border_thickness, @border_color)
    end
  end

  def update(mouse_x : Int32, mouse_y : Int32, clicked : Bool) : Nil
    if contains?(mouse_x, mouse_y)
      @state = clicked ? :pressed : :hover
      trigger_click if clicked
    else
      @state = :normal
    end
  end
end
