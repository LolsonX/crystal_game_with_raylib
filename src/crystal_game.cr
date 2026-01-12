require "./raylib"

CrystalRaylib.with_window(800, 600, "Hello from crystal".to_unsafe) do
  until CrystalRaylib.window_should_close
    Raylib.begin_drawing
    Raylib.end_drawing
  end
end
