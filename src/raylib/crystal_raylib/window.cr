module CrystalRaylib
  module Window
    def self.close_window
      LibRaylib.close_window
    end

    def self.init_window(width : Int32, height : Int32, title : Pointer(UInt8))
      LibRaylib.init_window(width, height, title)
    end

    def self.window_should_close : Bool
      LibRaylib.window_should_close
    end

    def self.with_window(width : Int32, height : Int32, title : Pointer(UInt8), &)
      init_window(width, height, title)
      begin
        yield
      ensure
        close_window()
      end
    end
  end
end
