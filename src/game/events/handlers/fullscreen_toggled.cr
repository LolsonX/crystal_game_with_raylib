module Events
  module Handlers
    class FullscreenToggled < Base
      def handle(event : Events::Base) : Bool
        return true unless event.is_a?(Events::FullscreenToggled)
        Settings::Registry.instance.set("fullscreen", event.value?)
        Settings::Registry.instance.save
        CrystalRaylib::Window.toggle_fullscreen
        true
      end
    end
  end
end
