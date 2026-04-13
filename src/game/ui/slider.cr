class UI::Slider < UI::Element
  include Traits::TimerUpdatable

  HANDLE_RADIUS = 8.0_f32
  TRACK_HEIGHT  = 6.0_f32

  property value : Float32
  getter min : Float32
  getter max : Float32
  property on_change : Proc(Float32, Nil)?

  def initialize(
    label : String,
    @min : Float32 = 0.0_f32,
    @max : Float32 = 100.0_f32,
    @value : Float32 = 50.0_f32,
    location : Core::Geometry::Location = Core::Geometry::Location.new,
    track_width : Float32 = 200.0_f32,
    @font_size : Int32 = 18,
    @label_color : CrystalRaylib::Types::Color = CrystalRaylib::Colors::WHITE,
    @track_color : CrystalRaylib::Types::Color = CrystalRaylib::Colors::DARK_GRAY,
    @fill_color : CrystalRaylib::Types::Color = CrystalRaylib::Colors::SKY_BLUE,
    @handle_color : CrystalRaylib::Types::Color = CrystalRaylib::Colors::WHITE,
  )
    @label = label
    @track_width = track_width
    @dragging = false
    total_height = {@font_size.to_f32 + 8, TRACK_HEIGHT + HANDLE_RADIUS * 2}.max
    dimension = Core::Geometry::Dimension.new(width: track_width, height: total_height)
    super(location: location, dimension: dimension)
  end

  def draw : Nil
    draw_label
    track_y = (y + @font_size + 8).to_i32
    draw_track(track_y)
    draw_filled(track_y)
    draw_handle(track_y)
    draw_value_text
  end

  def update(mouse_x : Int32, mouse_y : Int32, clicked : Bool) : Nil
    track_y = y + @font_size + 8

    if clicked
      if @dragging || handle_hit?(mouse_x.to_f32, mouse_y.to_f32, track_y)
        @dragging = true
        update_value_from_mouse(mouse_x)
      elsif in_track_bounds?(mouse_x.to_f32, mouse_y.to_f32, track_y)
        @dragging = true
        update_value_from_mouse(mouse_x)
      end
    else
      @dragging = false
    end
  end

  def update_timers(dt : Float32)
  end

  def value=(v : Float32)
    @value = v.clamp(@min, @max)
  end

  private def draw_label
    CrystalRaylib::Text.draw_text(@label, x.to_i32, y.to_i32, @font_size, @label_color)
  end

  private def draw_track(track_y : Int32)
    CrystalRaylib::Shapes.draw_rectangle(
      x.to_i32, track_y, @track_width.to_i32, TRACK_HEIGHT.to_i32, @track_color
    )
  end

  private def draw_filled(track_y : Int32)
    if @max > @min
      ratio = (@value - @min) / (@max - @min)
      fill_width = (ratio * @track_width).to_i32
    else
      fill_width = 0
    end
    CrystalRaylib::Shapes.draw_rectangle(
      x.to_i32, track_y, fill_width, TRACK_HEIGHT.to_i32, @fill_color
    )
  end

  private def draw_handle(track_y : Int32)
    if @max > @min
      ratio = (@value - @min) / (@max - @min)
    else
      ratio = 0.0_f32
    end
    handle_x = (x + ratio * @track_width).to_i32
    handle_y = (track_y + TRACK_HEIGHT / 2).to_i32
    CrystalRaylib::Shapes.draw_polygon(
      CrystalRaylib::Types::Vector2.new(x: handle_x.to_f32, y: handle_y.to_f32),
      20, HANDLE_RADIUS, 0.0_f32, @handle_color
    )
  end

  private def draw_value_text
    value_str = @value.to_i.to_s
    CrystalRaylib::Text.draw_text(
      value_str, (x + @track_width + 10).to_i32, y.to_i32, @font_size, @label_color
    )
  end

  private def handle_hit?(mouse_x : Float32, mouse_y : Float32, track_y : Float32) : Bool
    if @max > @min
      ratio = (@value - @min) / (@max - @min)
    else
      ratio = 0.0_f32
    end
    handle_x = x + ratio * @track_width
    handle_y = track_y + TRACK_HEIGHT / 2
    dx = mouse_x - handle_x
    dy = mouse_y - handle_y
    (dx * dx + dy * dy) <= (HANDLE_RADIUS + 4) * (HANDLE_RADIUS + 4)
  end

  private def in_track_bounds?(mouse_x : Float32, mouse_y : Float32, track_y : Float32) : Bool
    mouse_x >= x && mouse_x <= x + @track_width &&
      mouse_y >= track_y - HANDLE_RADIUS && mouse_y <= track_y + TRACK_HEIGHT + HANDLE_RADIUS
  end

  private def update_value_from_mouse(mouse_x : Int32)
    if @track_width > 0
      ratio = ((mouse_x.to_f32 - x) / @track_width).clamp(0.0_f32, 1.0_f32)
    else
      ratio = 0.0_f32
    end
    new_value = @min + ratio * (@max - @min)
    self.value = new_value
    @on_change.try(&.call(@value))
  end
end
