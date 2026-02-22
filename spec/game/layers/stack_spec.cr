require "../../spec_helper"

class TestLayer < Layers::Base
  include Traits::WorldDrawable
  include Traits::Eventable

  def draw; end

  def emit; end
end

describe Layers::Stack do
  context "when pushing layers onto the stack" do
    it "adds the layer to the stack" do
      stack = Layers::Stack.new
      layer = Layers::Base.new(priority: 0)

      stack.push(layer)

      stack.layers.size.should eq(1)
      stack.layers.first.should be(layer)
    end

    it "sorts layers by priority ascending so higher priority draws last" do
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

  context "when filtering layers by trait" do
    it "returns only layers that include the specified trait" do
      stack = Layers::Stack.new
      drawable_layer = TestLayer.new(priority: 1)
      base_layer = Layers::Base.new(priority: 0)

      stack.push(drawable_layer)
      stack.push(base_layer)

      result = stack.layers_with_trait(Traits::WorldDrawable)

      result.size.should eq(1)
      result.first.should be(drawable_layer)
    end

    it "returns an empty array when no layers have the trait" do
      stack = Layers::Stack.new
      stack.push(Layers::Base.new(priority: 0))

      result = stack.layers_with_trait(Traits::WorldDrawable)

      result.should be_empty
    end
  end

  context "when iterating over layers with a trait" do
    it "yields each layer with the specified trait" do
      stack = Layers::Stack.new
      layer1 = TestLayer.new(priority: 1)
      layer2 = TestLayer.new(priority: 2)

      stack.push(layer1)
      stack.push(layer2)

      yielded = [] of Layers::Base
      stack.each_with_trait(Traits::WorldDrawable) { |layer| yielded << layer }

      yielded.size.should eq(2)
    end
  end
end
