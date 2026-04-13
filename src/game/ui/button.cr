class UI::Button < UI::Element
  include Traits::Clickable
  include Traits::TimerUpdatable

  PRESSED_DURATION = 0.1_f32

  property hover_color : CrystalRaylib::Types::Color
  property pressed_color : CrystalRaylib::Types::Color

  def initialize(
    location : Core::Geometry::Location = Core::Geometry::Location.new(x: 0.0_f32, y: 0.0_f32),
    dimension : Core::Geometry::Dimension = Core::Geometry::Dimension.new(width: 120.0_f32, height: 40.0_f32),
    style : Core::Styles::Element = Core::Styles::Element.new,
    @hover_color : CrystalRaylib::Types::Color = CrystalRaylib::Colors::GRAY,
    @pressed_color : CrystalRaylib::Types::Color = CrystalRaylib::Colors::SKY_BLUE,
    @text : String? = nil,
    @font_size : Int32 = 18,
    @text_color : CrystalRaylib::Types::Color = CrystalRaylib::Colors::WHITE,
  )
    final_dimension = dimension

    if text = @text
      text_width = CrystalRaylib::Text.measure(text, @font_size).to_f32
      padding = (@font_size * 2).to_f32
      final_width = [dimension.width, text_width + padding].max
      final_dimension = Core::Geometry::Dimension.new(width: final_width, height: dimension.height)
    end

    super(location, final_dimension, style)
    @state = :normal
    @pressed_timer = 0.0_f32
    @mouse_in_bounds = false
    @hover_mouse_x = -1
    @hover_mouse_y = -1
  end

  def draw : Nil
    color = select_color

    CrystalRaylib::Shapes.draw_rectangle(x.to_i32, y.to_i32, width.to_i32, height.to_i32, color)
    draw_border

    if @text
      draw_text
    end
  end

  def update(mouse_x : Int32, mouse_y : Int32, clicked : Bool) : Nil
    @mouse_in_bounds = contains?(mouse_x.to_f32, mouse_y.to_f32)
    @hover_mouse_x = mouse_x
    @hover_mouse_y = mouse_y

    if @mouse_in_bounds
      handle_click_state(clicked)
    else
      @state = :normal
    end
  end

  private def handle_click_state(clicked : Bool)
    if clicked
      @state = :pressed
      @pressed_timer = PRESSED_DURATION
      trigger_click
    elsif @pressed_timer <= 0
      @state = :hover
    else
      @state = :pressed
    end
  end

  private def select_color
    case @state
    when :hover
      @hover_color
    when :pressed
      @pressed_color
    else
      style.background_color
    end
  end

  private def draw_text
    if text = @text
      text_width = CrystalRaylib::Text.measure(text, @font_size)
      x_center = (x + width / 2 - text_width / 2).to_i32
      y_center = (y + (height - @font_size) / 2).to_i32
      CrystalRaylib::Text.draw_text(text, x_center, y_center, @font_size, @text_color)
    end
  end

  def update_timers(dt : Float32)
    if @pressed_timer > 0
      @pressed_timer -= dt
    else
      update(@hover_mouse_x, @hover_mouse_y, false)
    end
  end
end
