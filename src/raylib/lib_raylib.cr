@[Link(ldflags: "-L#{__DIR__}/.. -lraylib -lm")]
lib LibRaylib
  struct Camera2D
    offset : Vector2
    target : Vector2
    rotation : Float32
    zoom : Float32
  end

  struct Color
    r : UInt8
    g : UInt8
    b : UInt8
    a : UInt8
  end

  struct Vector2
    x : Float32
    y : Float32
  end

  struct Rectangle
    x : Float32
    y : Float32
    width : Float32
    height : Float32
  end

  # Window
  fun init_window = InitWindow(width : Int32, height : Int32, title : Pointer(UInt8))
  fun close_window = CloseWindow
  fun window_should_close = WindowShouldClose : Bool

  # Drawing
  fun begin_drawing = BeginDrawing
  fun end_drawing = EndDrawing

  # Camera 2D
  fun begin_mode_2d = BeginMode2D(camera : Camera2D)
  fun end_mode_2d = EndMode2D

  # Background
  fun clear_background = ClearBackground(color : Color)

  # Shapes
  fun draw_polygon = DrawPoly(center : Vector2, sides : Int32, radius : Float32, rotation : Float32, color : Color)
  fun draw_rectangle = DrawRectangle(x : Int32, y : Int32, width : Int32, height : Int32, color : Color)
  fun draw_triangle = DrawTriangle(vertex_1 : Vector2, vertex_2 : Vector2, vertex_3 : Vector2, color : Color)
  fun draw_triangle_fan = DrawTriangleFan(points : Pointer(Vector2), point_count : Int32, color : Color)
  fun draw_line_ex = DrawLineEx(start_pos : Vector2, end_pos : Vector2, thickness : Float32, color : Color)
  fun draw_rectangle_lines = DrawRectangleLines(x : Int32, y : Int32, width : Int32, height : Int32, color : Color)
  fun draw_rectangle_lines_ex = DrawRectangleLinesEx(rec : Rectangle, line_thick : Float32, color : Color)
  # Input
  fun key_pressed = GetKeyPressed : Int32
  fun key_down? = IsKeyDown(key_code : Int32) : Bool
  fun mouse_position = GetMousePosition : Vector2

  # Text
  fun draw_fps = DrawFPS(x : Int32, y : Int32)
  fun draw_text = DrawText(text : Pointer(UInt8), x : Int32, y : Int32, font_size : Int32, color : Color)

  # Timing
  fun set_target_fps = SetTargetFPS(fps : Int32)
  fun frame_time = GetFrameTime : Float32

  # Conversion
  fun get_screen_to_world_2d = GetScreenToWorld2D(vector : Vector2, camera : Camera2D) : Vector2
  fun get_world_to_screen_2d = GetWorldToScreen2D(vector : Vector2, camera : Camera2D) : Vector2
end
