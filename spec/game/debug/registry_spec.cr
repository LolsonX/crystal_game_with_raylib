require "../../spec_helper"

describe DebugRegistry do
  before_each do
    registry = DebugRegistry.instance
    registry.definitions.clear
    registry.values.clear
    registry.hidden_items.clear
    registry.hidden_categories.clear
  end

  describe ".instance" do
    it "returns a singleton instance" do
      r1 = DebugRegistry.instance
      r2 = DebugRegistry.instance
      r1.should be(r2)
    end
  end

  describe "#register" do
    it "adds item definition" do
      DebugRegistry.register("fps", "FPS", "performance")

      DebugRegistry.instance.definitions.has_key?("fps").should be_true
    end
  end

  describe "#set and #get" do
    it "sets and gets value" do
      DebugRegistry.register("fps", "FPS", "performance")
      DebugRegistry.set("fps", "60")

      DebugRegistry.get("fps").should eq("60")
    end

    it "returns nil for unknown key" do
      DebugRegistry.get("unknown").should be_nil
    end
  end

  describe "#hide and #show" do
    it "hides item" do
      DebugRegistry.register("fps", "FPS", "performance")
      DebugRegistry.hide("fps")

      DebugRegistry.visible?("fps").should be_false
    end

    it "shows hidden item" do
      DebugRegistry.register("fps", "FPS", "performance")
      DebugRegistry.hide("fps")
      DebugRegistry.show("fps")

      DebugRegistry.visible?("fps").should be_true
    end
  end

  describe "#hide_category and #show_category" do
    it "hides category" do
      DebugRegistry.hide_category("debug")

      DebugRegistry.category_visible?("debug").should be_false
    end

    it "shows hidden category" do
      DebugRegistry.hide_category("debug")
      DebugRegistry.show_category("debug")

      DebugRegistry.category_visible?("debug").should be_true
    end
  end

  describe "#visible?" do
    it "returns true for non-hidden item" do
      DebugRegistry.register("fps", "FPS", "performance")

      DebugRegistry.visible?("fps").should be_true
    end
  end

  describe "#unregister" do
    it "removes item from definitions" do
      DebugRegistry.register("fps", "FPS", "performance")
      DebugRegistry.unregister("fps")

      DebugRegistry.instance.definitions.has_key?("fps").should be_false
    end

    it "removes item from values" do
      DebugRegistry.register("fps", "FPS", "performance")
      DebugRegistry.set("fps", "60")
      DebugRegistry.unregister("fps")

      DebugRegistry.instance.values.has_key?("fps").should be_false
    end

    it "removes item from hidden_items" do
      DebugRegistry.register("fps", "FPS", "performance")
      DebugRegistry.hide("fps")
      DebugRegistry.unregister("fps")

      DebugRegistry.instance.hidden_items.includes?("fps").should be_false
    end
  end

  describe "#items_by_category" do
    it "groups items by category" do
      DebugRegistry.register("fps", "FPS", "performance")
      DebugRegistry.register("memory", "Memory", "performance")
      DebugRegistry.register("position", "Position", "debug")

      items = DebugRegistry.items_by_category

      items["performance"].size.should eq(2)
      items["debug"].size.should eq(1)
    end

    it "excludes hidden items" do
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
