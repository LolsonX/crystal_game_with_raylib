require "json"
require "file_utils"

module Settings
  class Registry
    @@instance : Registry?

    getter values : Hash(String, JSON::Any)

    DEFAULT_PATH = File.expand_path("~/.config/crystal_game/settings.json")

    DEFAULTS = {
      "camera_speed"      => 1500,
      "fullscreen"        => false,
      "resolution_width"  => 1920,
      "resolution_height" => 1080,
    }

    def initialize
      @values = Hash(String, JSON::Any).new
    end

    def self.instance
      @@instance ||= new
    end

    def load(path : String = DEFAULT_PATH)
      unless File.exists?(path)
        apply_defaults
        return
      end

      raw = File.read(path)
      parsed = JSON.parse(raw)
      parsed.as_h.each do |key, value|
        @values[key] = value
      end
      apply_defaults
    end

    def save(path : String = DEFAULT_PATH)
      dir = File.dirname(path)
      FileUtils.mkdir_p(dir)
      File.write(path, @values.to_json)
    end

    def get_int(key : String, default : Int32) : Int32
      @values[key]?.try(&.as_i?) || default
    end

    def get_float(key : String, default : Float32) : Float32
      val = @values[key]?.try(&.as_f?)
      val ? val.to_f32 : default
    end

    def get_bool(key : String, default : Bool) : Bool
      @values[key]?.try(&.as_bool?) || default
    end

    def get_string(key : String, default : String = "") : String
      @values[key]?.try(&.as_s?) || default
    end

    def set(key : String, value : Int32)
      @values[key] = JSON::Any.new(value)
    end

    def set(key : String, value : Float64)
      @values[key] = JSON::Any.new(value)
    end

    def set(key : String, value : Bool)
      @values[key] = JSON::Any.new(value)
    end

    def set(key : String, value : String)
      @values[key] = JSON::Any.new(value)
    end

    private def apply_defaults
      DEFAULTS.each do |key, value|
        @values[key] ||= JSON::Any.new(value)
      end
    end
  end
end
