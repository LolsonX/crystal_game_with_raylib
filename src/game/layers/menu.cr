module Layers
  class Menu < Base
    include Traits::ScreenDrawable
    include Traits::Eventable

    property visible : Bool = false
    property elements : Array(UI::Element)

    def initialize(@priority : Int32 = 100)
      @elements = [] of UI::Element
      subscribe_handler(mouse_pressed_handler, Events::MousePressed)
      subscribe_handler(mouse_position_handler, Events::MousePositionChanged)
    end

    def draw : Nil
      return unless visible
      @elements.each(&.draw)
    end

    private def mouse_pressed_handler : Events::Handlers::CallbackHandler
      @mouse_pressed_handler ||= Events::Handlers::CallbackHandler.new(
        handler: ->(event : Events::Base) { on_mouse_pressed(event) }
      )
    end

    private def on_mouse_pressed(event : Events::Base) : Bool
      return true unless visible
      return true unless event.is_a?(Events::MousePressed)

      @elements.each do |element|
        if element.contains?(event.screen_x, event.screen_y)
          element.update(event.screen_x, event.screen_y, clicked: true)
          return false
        end
      end
      true
    end

    private def mouse_position_handler : Events::Handlers::CallbackHandler
      @mouse_position_handler ||= Events::Handlers::CallbackHandler.new(
        handler: ->(event : Events::Base) { on_mouse_position_changed(event) }
      )
    end

    private def on_mouse_position_changed(event : Events::Base) : Bool
      return true unless visible
      return true unless event.is_a?(Events::MousePositionChanged)

      @elements.each do |element|
        element.update(event.new_position.screen_x.to_i, event.new_position.screen_y.to_i, clicked: false)
      end
      true
    end
  end
end