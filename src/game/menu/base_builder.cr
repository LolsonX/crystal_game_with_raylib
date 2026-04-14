module Menu
  abstract class BaseBuilder
    getter elements : Array(UI::Element)

    def self.build
      new.build
    end

    def initialize
      @elements = [] of UI::Element
    end

    abstract def build : BaseBuilder

    protected def add(element : UI::Element)
      @elements << element
    end
  end
end
