require "../../spec_helper"

describe Debug::Registry do
  before_each do
    registry = Debug::Registry.instance
    registry.definitions.clear
    registry.values.clear
    registry.hidden_items.clear
    registry.hidden_categories.clear
  end

  context "when hiding an item" do
    it "marks the item as not visible" do
      Debug::Registry.register("fps", "FPS", "performance")
      Debug::Registry.hide("fps")

      Debug::Registry.visible?("fps").should be_false
    end
  end

  context "when showing a previously hidden item" do
    it "marks the item as visible again" do
      Debug::Registry.register("fps", "FPS", "performance")
      Debug::Registry.hide("fps")
      Debug::Registry.show("fps")

      Debug::Registry.visible?("fps").should be_true
    end
  end

  context "when hiding a category" do
    it "marks the category as not visible" do
      Debug::Registry.hide_category("debug")

      Debug::Registry.category_visible?("debug").should be_false
    end
  end

  context "when showing a previously hidden category" do
    it "marks the category as visible again" do
      Debug::Registry.hide_category("debug")
      Debug::Registry.show_category("debug")

      Debug::Registry.category_visible?("debug").should be_true
    end
  end

  context "when unregistering an item" do
    it "removes the item from all internal collections" do
      Debug::Registry.register("fps", "FPS", "performance")
      Debug::Registry.set("fps", "60")
      Debug::Registry.hide("fps")
      Debug::Registry.unregister("fps")

      Debug::Registry.instance.definitions.has_key?("fps").should be_false
      Debug::Registry.instance.values.has_key?("fps").should be_false
      Debug::Registry.instance.hidden_items.includes?("fps").should be_false
    end
  end

  context "when grouping items by category" do
    it "groups items by their category" do
      Debug::Registry.register("fps", "FPS", "performance")
      Debug::Registry.register("memory", "Memory", "performance")
      Debug::Registry.register("position", "Position", "debug")

      items = Debug::Registry.items_by_category

      items["performance"].size.should eq(2)
      items["debug"].size.should eq(1)
    end

    it "excludes hidden items from the grouping" do
      Debug::Registry.register("fps", "FPS", "performance")
      Debug::Registry.register("memory", "Memory", "performance")
      Debug::Registry.hide("fps")

      items = Debug::Registry.items_by_category

      items["performance"].size.should eq(1)
      items["performance"].first[0].key.should eq("memory")
    end

    it "excludes items from hidden categories" do
      Debug::Registry.register("fps", "FPS", "performance")
      Debug::Registry.register("position", "Position", "debug")
      Debug::Registry.hide_category("debug")

      items = Debug::Registry.items_by_category

      items.has_key?("debug").should be_false
      items["performance"].size.should eq(1)
    end

    it "includes definition and value pairs" do
      Debug::Registry.register("fps", "FPS", "performance")
      Debug::Registry.set("fps", "60")

      items = Debug::Registry.items_by_category
      item = items["performance"].first

      item[0].key.should eq("fps")
      item[1].should eq("60")
    end

    it "includes nil value for unset items" do
      Debug::Registry.register("fps", "FPS", "performance")

      items = Debug::Registry.items_by_category
      item = items["performance"].first

      item[1].should be_nil
    end
  end
end
