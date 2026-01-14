require "./raylib/raylib"
require "./game/window"
require "./game/entities/player"

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
