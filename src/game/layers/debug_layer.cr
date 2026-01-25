module Layers
  class DebugLayer < Base
    include Traits::Drawable
    include Traits::EventProcessable

    private getter x : Int32
    private getter y : Int32
    private getter height : Int32
    private getter width : Int32
    private getter text_color : CrystalRaylib::Types::Color
    private getter background_color : CrystalRaylib::Types::Color
    private getter camera : CrystalRaylib::Types::Camera2D

    def initialize(@camera : CrystalRaylib::Types::Camera2D, @priority : Int32 = -1, @visible : Bool = true)
      @x = 600
      @y = 10
      @width = 420
      @height = 900
      @text_color = CrystalRaylib::Colors::BLACK
      @background_color = CrystalRaylib::Types::Color.new(red: 128, green: 128, blue: 128, alpha: 128)
    end

    def draw
      draw_background
      draw_fps
      draw_mouse_position
    end

    def draw_background
      CrystalRaylib::Shapes.draw_rectangle(x: x, y: y, height: height, width: width, color: background_color)
    end

    def draw_fps
      CrystalRaylib::Text.draw_text(text: "FPS: #{1 // frame_time}", x: @x + 5, y: @y + 5, size: 20, color: text_color)
    end

    def draw_mouse_position
      position = mouse_position
      world_position = CrystalRaylib::Camera2D.screen_to_world_2d(vector: position, camera: camera)
      CrystalRaylib::Text.draw_text(text: "Mouse position x: #{position.x} y: #{position.y}", x: @x + 5, y: @y + 30, size: 20, color: text_color)
      CrystalRaylib::Text.draw_text(text: "Mouse position x: #{world_position.x} y: #{world_position.y}", x: @x + 5, y: @y + 60, size: 20, color: text_color)
    end

    def frame_time
      [CrystalRaylib::Timing.frame_time, 0.0000001].max
    end

    def mouse_position
      CrystalRaylib::Input.mouse_position
    end
  end
end
