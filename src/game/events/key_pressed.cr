module Events
  class KeyPressed < Base
    getter key : Int32

    def initialize(@key : Int32); end
  end
end
