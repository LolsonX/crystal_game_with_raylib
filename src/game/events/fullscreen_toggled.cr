module Events
  class FullscreenToggled < Base
    getter? value : Bool

    def initialize(@value : Bool)
    end
  end
end
