class UI::Label < UI::Element
  def initialize(
    text : String,
    location : Core::Geometry::Location = Core::Geometry::Location.new,
    @font_size : Int32 = 18,
    @text_color : CrystalRaylib::Types::Color = CrystalRaylib::Colors::WHITE,
  )
    text_width = CrystalRaylib::Text.measure(text, @font_size).to_f32
    dimension = Core::Geometry::Dimension.new(width: text_width, height: @font_size.to_f32)
    @text = text
    super(location: location, dimension: dimension)
  end

  def draw : Nil
    CrystalRaylib::Text.draw_text(@text, x.to_i32, y.to_i32, @font_size, @text_color)
  end

  def update(mouse_x : Int32, mouse_y : Int32, clicked : Bool) : Nil
  end
end
