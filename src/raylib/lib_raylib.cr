@[Link(ldflags: "-L#{__DIR__}/.. -lraylib -lm")]
lib LibRaylib
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
