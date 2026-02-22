require "../../spec_helper"

describe DebugRegistry do
  before_each do
    registry = DebugRegistry.instance
    registry.definitions.clear
    registry.values.clear
    registry.hidden_items.clear
    registry.hidden_categories.clear
  end

  context "when hiding an item" do
    it "marks the item as not visible" do
      DebugRegistry.register("fps", "FPS", "performance")
      DebugRegistry.hide("fps")

      DebugRegistry.visible?("fps").should be_false
    end
  end

  context "when showing a previously hidden item" do
    it "marks the item as visible again" do
      DebugRegistry.register("fps", "FPS", "performance")
      DebugRegistry.hide("fps")
      DebugRegistry.show("fps")

      DebugRegistry.visible?("fps").should be_true
    end
  end

  context "when hiding a category" do
    it "marks the category as not visible" do
      DebugRegistry.hide_category("debug")

      DebugRegistry.category_visible?("debug").should be_false
    end
  end

  context "when showing a previously hidden category" do
    it "marks the category as visible again" do
      DebugRegistry.hide_category("debug")
      DebugRegistry.show_category("debug")

      DebugRegistry.category_visible?("debug").should be_true
    end
  end

  context "when unregistering an item" do
    it "removes the item from all internal collections" do
      DebugRegistry.register("fps", "FPS", "performance")
      DebugRegistry.set("fps", "60")
      DebugRegistry.hide("fps")
      DebugRegistry.unregister("fps")

      DebugRegistry.instance.definitions.has_key?("fps").should be_false
      DebugRegistry.instance.values.has_key?("fps").should be_false
      DebugRegistry.instance.hidden_items.includes?("fps").should be_false
    end
  end

  context "when grouping items by category" do
    it "groups items by their category" do
      DebugRegistry.register("fps", "FPS", "performance")
      DebugRegistry.register("memory", "Memory", "performance")
      DebugRegistry.register("position", "Position", "debug")

      items = DebugRegistry.items_by_category

      items["performance"].size.should eq(2)
      items["debug"].size.should eq(1)
    end

    it "excludes hidden items from the grouping" do
      DebugRegistry.register("fps", "FPS", "performance")
      DebugRegistry.register("memory", "Memory", "performance")
      DebugRegistry.hide("fps")

      items = DebugRegistry.items_by_category

      items["performance"].size.should eq(1)
      items["performance"].first[0].key.should eq("memory")
    end

    it "excludes items from hidden categories" do
      DebugRegistry.register("fps", "FPS", "performance")
      DebugRegistry.register("position", "Position", "debug")
      DebugRegistry.hide_category("debug")

      items = DebugRegistry.items_by_category

      items.has_key?("debug").should be_false
      items["performance"].size.should eq(1)
    end

    it "includes definition and value pairs" do
      DebugRegistry.register("fps", "FPS", "performance")
      DebugRegistry.set("fps", "60")

      items = DebugRegistry.items_by_category
      item = items["performance"].first

      item[0].key.should eq("fps")
      item[1].should eq("60")
    end

    it "includes nil value for unset items" do
      DebugRegistry.register("fps", "FPS", "performance")

      items = DebugRegistry.items_by_category
      item = items["performance"].first

      item[1].should be_nil
    end
  end
end
