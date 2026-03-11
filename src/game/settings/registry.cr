module Settings
  class Registry
    @@instance : Registry?

    getter values : Hash(String, String)

    def initialize
      @@instance ||= new
      @values = Hash(String, String).new
    end

    def self.instance
      @@instance ||= new
    end
  end
end
