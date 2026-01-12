@[Link(ldflags: "-L#{__DIR__} -lraylib -lm")]
lib Raylib
  fun init_window = InitWindow(width : Int32, height : Int32, title : Pointer(UInt8))
  fun close_window = CloseWindow
  fun window_should_close = WindowShouldClose : Bool

  fun begin_drawing = BeginDrawing
  fun end_drawing = EndDrawing
end

module CrystalRaylib
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
end



