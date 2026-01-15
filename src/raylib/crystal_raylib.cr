module CrystalRaylib
  alias Color = LibRaylib::Color
  alias Camera2D = LibRaylib::Camera2D
  alias Vector2 = LibRaylib::Vector2

  extend self

  def init_window(width : Int32, height : Int32, title : Pointer(UInt8))
    LibRaylib.init_window(width, height, title)
  end

  def close_window
    LibRaylib.close_window
  end

  def with_window(width : Int32, height : Int32, title : Pointer(UInt8), &block)
    init_window(width, height, title)
    yield
    close_window()
  end

  def window_should_close : Bool
    LibRaylib.window_should_close
  end

  def begin_drawing
    LibRaylib.begin_drawing
  end

  def end_drawing
    LibRaylib.end_drawing
  end

  def draw(&block)
    begin_drawing()
    yield
    end_drawing()
  end

  def begin_mode_2d(camera : Camera2D)
    LibRaylib.begin_mode_2d(camera: camera)
  end

  def end_mode_2d
    LibRaylib.end_mode_2d
  end

  def with_mode_2d(camera : Camera2D, &)
    LibRaylib.begin_mode_2d(camera: camera)
    yield
    LibRaylib.end_mode_2d
  end

  def clear_background(color)
    LibRaylib.clear_background(color)
  end

  def draw_polygon(center : Vector2, sides : Int32, radius : Float32, rotation : Float32, color : Color)
    LibRaylib.draw_polygon(center: center, sides: sides, radius: radius, rotation: rotation, color: color)
  end

  def draw_rectangle(x : Int32, y : Int32, width : Int32, height : Int32, color : Color)
    LibRaylib.draw_rectangle(x, y, width, height, color)
  end

  def draw_triangle(vertex_1 : Vector2, vertex_2 : Vector2, vertex_3 : Vector2, color : Color)
    LibRaylib.draw_triangle(vertex_1: vertex_1, vertex_2: vertex_2, vertex_3: vertex_3, color: color)
  end

  def draw_triangle_fan(points : Array(Vector2), point_count : Int32, color : Color)
    LibRaylib.draw_triangle_fan(points: points, point_count: point_count, color: color)
  end

  def pressed_key : Int32
    LibRaylib.key_pressed
  end

  def key_down?(key_code : Int32) : Bool
    LibRaylib.key_down?(key_code)
  end

  def target_fps=(fps : Int32)
    LibRaylib.set_target_fps(fps)
  end

  def frame_time : Float32
    LibRaylib.frame_time
  end

  def screen_to_world_2d(vector : Vector2, camera : Camera2D) : Vector2
    LibRaylib.get_screen_to_world_2d(vector: vector, camera: camera)
  end
end
