require "../window"

struct DebugConfig
  struct Location
    getter screen_position : CrystalRaylib::Types::Vector2
    getter padding_top : Int32
    getter padding_left : Int32
    getter margin_top : Int32
    getter box_padding : Int32
    getter category_spacing : Int32

    def initialize(
      @screen_position = CrystalRaylib::Types::Vector2.new(
        x: (Window::WIDTH - 420 - 10).to_f32,
        y: 10.0_f32
      ),
      @padding_top = 5,
      @padding_left = 5,
      @margin_top = 30,
      @box_padding = 10,
      @category_spacing = 10,
    )
    end
  end

  struct Dimensions
    getter width : Int32
    getter height : Int32

    def initialize(@width = 420, @height = 900)
    end
  end

  struct Style
    getter text_color : CrystalRaylib::Types::Color
    getter background_color : CrystalRaylib::Types::Color
    getter category_color : CrystalRaylib::Types::Color
    getter outline_color : CrystalRaylib::Types::Color
    getter outline_thickness : Float32
    getter font_size : Int32

    def initialize(
      @text_color = CrystalRaylib::Colors::WHITE,
      @background_color = CrystalRaylib::Types::Color.new(red: 40, green: 40, blue: 40, alpha: 200),
      @category_color = CrystalRaylib::Colors::LIGHT_GRAY,
      @outline_color = CrystalRaylib::Colors::WHITE,
      @outline_thickness = 2.0_f32,
      @font_size = 20,
    )
    end
  end

  getter location : Location
  getter dimensions : Dimensions
  getter style : Style

  def initialize(
    @location = Location.new,
    @dimensions = Dimensions.new,
    @style = Style.new,
  )
  end

  def line_height
    style.font_size + location.margin_top
  end

  def start_x
    location.screen_position.x.to_i + location.box_padding + location.padding_left
  end

  def start_y
    location.screen_position.y.to_i + location.box_padding + location.padding_top
  end
end
