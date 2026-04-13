require "../../spec_helper"

describe Debug::Config do
  context "when calculating line height" do
    it "returns font_size plus margin_top" do
      style = Core::Style.new(text: Core::Style::Text.new(size: 20))
      box = Core::Geometry::Box.new(margin_top: 30)
      config = Debug::Config.new(box: box, style: style)

      config.line_height.should eq(50)
    end
  end

  context "when calculating start_x" do
    it "returns position.x plus box_padding plus padding_left" do
      position = Core::Geometry::Location.new(x: 600.0_f32, y: 10.0_f32)
      box = Core::Geometry::Box.new(position: position, box_padding: 10, padding_left: 5)
      config = Debug::Config.new(box: box)

      config.start_x.should eq(615)
    end
  end

  context "when calculating start_y" do
    it "returns position.y plus box_padding plus padding_top" do
      position = Core::Geometry::Location.new(x: 600.0_f32, y: 10.0_f32)
      box = Core::Geometry::Box.new(position: position, box_padding: 10, padding_top: 5)
      config = Debug::Config.new(box: box)

      config.start_y.should eq(25)
    end
  end
end
