module Layers
  class Menu < Base
    include Traits::ScreenDrawable
    include Traits::Eventable

    property visible : Bool = false
    property elements : Array(UI::Element)

    def initialize(@priority : Int32 = 100)
      @elements = [] of UI::Element
    end

    def draw : Nil
      return unless visible
      @elements.each(&.draw)
    end
  end
end
