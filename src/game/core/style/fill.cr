module Core
  module Styles
    struct Fill
      getter color : CrystalRaylib::Types::Color

      def initialize(@color : CrystalRaylib::Types::Color = CrystalRaylib::Types::Color.new(red: 40, green: 40, blue: 40, alpha: 255))
      end
    end
  end
end
