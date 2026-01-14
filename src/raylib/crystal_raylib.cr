module CrystalRaylib
  alias Color = LibRaylib::Color
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

  def clear_background(color)
    LibRaylib.clear_background(color)
  end

  def draw_rectangle(x : Int32, y : Int32, width : Int32, height : Int32, color : Color)
    LibRaylib.draw_rectangle(x, y, width, height, color)
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
end
