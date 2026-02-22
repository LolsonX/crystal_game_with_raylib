require "../../spec_helper"

describe Debug::Config do
  context "when calculating line height" do
    it "returns font_size plus margin_top" do
      config = Debug::Config.new(
        style: Debug::Config::Style.new(font_size: 20),
        location: Debug::Config::Location.new(margin_top: 30)
      )

      config.line_height.should eq(50)
    end
  end

  context "when calculating start_x" do
    it "returns screen_position.x plus box_padding plus padding_left" do
      config = Debug::Config.new(
        location: Debug::Config::Location.new(
          screen_position: CrystalRaylib::Types::Vector2.new(x: 600, y: 10),
          box_padding: 10,
          padding_left: 5
        )
      )

      config.start_x.should eq(615)
    end
  end

  context "when calculating start_y" do
    it "returns screen_position.y plus box_padding plus padding_top" do
      config = Debug::Config.new(
        location: Debug::Config::Location.new(
          screen_position: CrystalRaylib::Types::Vector2.new(x: 600, y: 10),
          box_padding: 10,
          padding_top: 5
        )
      )

      config.start_y.should eq(25)
    end
  end
end
