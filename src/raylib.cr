@[Link(ldflags: "-L#{__DIR__} -lraylib -lm")]
lib Raylib
  struct Color
    r : UInt8
    g : UInt8
    b : UInt8
    a : UInt8
  end

  fun init_window = InitWindow(width : Int32, height : Int32, title : Pointer(UInt8))
  fun close_window = CloseWindow
  fun window_should_close = WindowShouldClose : Bool

  fun begin_drawing = BeginDrawing
  fun end_drawing = EndDrawing

  fun clear_background = ClearBackground(color : Color)
  fun draw_rectangle = DrawRectangle(x : Int32, y : Int32, width : Int32, height : Int32, color : Color)

  fun key_pressed = GetKeyPressed : Int32
  fun key_down? = IsKeyDown(key_code : Int32) : Bool

  fun set_target_fps = SetTargetFPS(fps : Int32)

  fun frame_time = GetFrameTime : Float32
end

module CrystalRaylib
  alias Color = Raylib::Color
  extend self

  def init_window(width : Int32, height : Int32, title : Pointer(UInt8))
    Raylib.init_window(width, height, title)
  end

  def close_window
    Raylib.close_window
  end

  def with_window(width : Int32, height : Int32, title : Pointer(UInt8), &block)
    init_window(width, height, title)
    yield
    close_window()
  end

  def window_should_close : Bool
    Raylib.window_should_close
  end

  def begin_drawing
    Raylib.begin_drawing
  end

  def end_drawing
    Raylib.end_drawing
  end

  def draw(&block)
    begin_drawing()
    yield
    end_drawing()
  end

  def clear_background(color)
    Raylib.clear_background(color)
  end

  def draw_rectangle(x : Int32, y : Int32, width : Int32, height : Int32, color : Color)
    Raylib.draw_rectangle(x, y, width, height, color)
  end

  def pressed_key : Int32
    Raylib.key_pressed
  end

  def key_down?(key_code : Int32) : Bool
    Raylib.key_down?(key_code)
  end

  def target_fps=(fps : Int32)
    Raylib.set_target_fps(fps)
  end

  def frame_time : Float32
    Raylib.frame_time
  end
end
