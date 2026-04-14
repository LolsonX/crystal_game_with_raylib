module Events
  class ResolutionChanged < Base
    getter width : Int32
    getter height : Int32

    def initialize(@width : Int32, @height : Int32)
    end
  end
end
