require "./raylib"

class Window
  WIDTH  = 1920
  HEIGHT = 1080
end

class Player
  property x : Int32
  property y : Int32
  property color : CrystalRaylib::Color

  HEIGHT = 30
  WIDTH = 40

  VELOCITY = 100

  def initialize(@x : Int32, @y : Int32, @color = CrystalRaylib::Color.new(r: 200, g: 31, b: 31, a: 255))
  end

  def draw
    CrystalRaylib.draw_rectangle(x: x - (WIDTH // 2), y: y - (HEIGHT // 2), width: WIDTH, height: HEIGHT, color: color)
  end
end

CrystalRaylib.with_window(Window::WIDTH, Window::HEIGHT, "Hello from crystal".to_unsafe) do
  player = Player.new(x: Window::WIDTH // 2, y: Window::HEIGHT // 2 )
  CrystalRaylib.target_fps = 60
  until CrystalRaylib.window_should_close
    CrystalRaylib.draw do
      CrystalRaylib.clear_background(CrystalRaylib::Color.new(r: 31, g: 31, b: 31, a: 255))
      player.draw

      delta_time = CrystalRaylib.frame_time

      if CrystalRaylib.key_down?(265)
        player.y -= (Player::VELOCITY * delta_time).to_i32
      elsif CrystalRaylib.key_down?(264)
        player.y += (Player::VELOCITY * delta_time).to_i32
      elsif CrystalRaylib.key_down?(263)
        player.x -= (Player::VELOCITY * delta_time).to_i32
      elsif CrystalRaylib.key_down?(262)
        player.x += (Player::VELOCITY * delta_time).to_i32
      end
    end
  end
end
