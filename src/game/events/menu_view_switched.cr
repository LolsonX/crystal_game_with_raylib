module Events
  class MenuViewSwitched < Base
    getter view : Symbol

    def initialize(@view : Symbol)
    end
  end
end
