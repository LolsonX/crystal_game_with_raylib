require "../../spec_helper"

class TestLayer < Layers::Base
  include Traits::Drawable
  include Traits::Eventable

  def draw; end

  def emit; end
end

describe Layers::Stack do
  describe "#push" do
    it "adds layer to stack" do
      stack = Layers::Stack.new
      layer = Layers::Base.new(priority: 0)

      stack.push(layer)

      stack.layers.size.should eq(1)
      stack.layers.first.should be(layer)
    end

    it "sorts layers by priority ascending so higher priority draws last (visible)" do
      stack = Layers::Stack.new
      layer1 = Layers::Base.new(priority: 1)
      layer2 = Layers::Base.new(priority: 3)
      layer3 = Layers::Base.new(priority: 2)

      stack.push(layer1)
      stack.push(layer2)
      stack.push(layer3)

      stack.layers[0].priority.should eq(1)
      stack.layers[1].priority.should eq(2)
      stack.layers[2].priority.should eq(3)
    end
  end

  describe "#layers_with_trait" do
    it "returns only layers with specified trait" do
      stack = Layers::Stack.new
      drawable_layer = TestLayer.new(priority: 1)
      base_layer = Layers::Base.new(priority: 0)

      stack.push(drawable_layer)
      stack.push(base_layer)

      result = stack.layers_with_trait(Traits::Drawable)

      result.size.should eq(1)
      result.first.should be(drawable_layer)
    end

    it "returns empty array when no layers have trait" do
      stack = Layers::Stack.new
      stack.push(Layers::Base.new(priority: 0))

      result = stack.layers_with_trait(Traits::Drawable)

      result.should be_empty
    end
  end

  describe "#each_with_trait" do
    it "yields layers with specified trait" do
      stack = Layers::Stack.new
      layer1 = TestLayer.new(priority: 1)
      layer2 = TestLayer.new(priority: 2)

      stack.push(layer1)
      stack.push(layer2)

      yielded = [] of Layers::Base
      stack.each_with_trait(Traits::Drawable) { |layer| yielded << layer }

      yielded.size.should eq(2)
    end
  end
end
