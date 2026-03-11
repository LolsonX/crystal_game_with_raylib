module Traits
  module Clickable
    property on_click : Proc(Nil)?

    def trigger_click
      if handler = @on_click
        handler.call
      end
    end
  end
end
