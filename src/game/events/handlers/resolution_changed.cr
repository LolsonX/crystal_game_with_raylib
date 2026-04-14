module Events
  module Handlers
    class ResolutionChanged < Base
      def handle(event : Events::Base) : Bool
        return true unless event.is_a?(Events::ResolutionChanged)
        Settings::Registry.instance.set("resolution_width", event.width)
        Settings::Registry.instance.set("resolution_height", event.height)
        Settings::Registry.instance.save
        CrystalRaylib::Window.set_window_size(event.width, event.height)
        true
      end
    end
  end
end
