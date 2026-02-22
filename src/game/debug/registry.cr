module Debug
  class Registry
    record ItemDefinition, key : String, label : String, category : String

    @@instance : Registry?

    getter definitions : Hash(String, ItemDefinition)
    getter values : Hash(String, String)
    getter hidden_items : Set(String)
    getter hidden_categories : Set(String)

    def initialize
      @definitions = Hash(String, ItemDefinition).new
      @values = Hash(String, String).new
      @hidden_items = Set(String).new
      @hidden_categories = Set(String).new
    end

    def self.instance : Registry
      @@instance ||= new
    end

    def self.register(key : String, label : String, category : String) : Void
      instance.register(key, label, category)
    end

    def self.set(key : String, value : String) : Void
      instance.set(key, value)
    end

    def self.get(key : String) : String?
      instance.get(key)
    end

    def self.hide(key : String) : Void
      instance.hide(key)
    end

    def self.show(key : String) : Void
      instance.show(key)
    end

    def self.visible?(key : String) : Bool
      instance.visible?(key)
    end

    def self.hide_category(category : String) : Void
      instance.hide_category(category)
    end

    def self.show_category(category : String) : Void
      instance.show_category(category)
    end

    def self.category_visible?(category : String) : Bool
      instance.category_visible?(category)
    end

    def self.unregister(key : String) : Void
      instance.unregister(key)
    end

    def self.items_by_category : Hash(String, Array({ItemDefinition, String?}))
      instance.items_by_category
    end

    def register(key : String, label : String, category : String) : Void
      @definitions[key] = ItemDefinition.new(key, label, category)
    end

    def set(key : String, value : String) : Void
      @values[key] = value
    end

    def get(key : String) : String?
      @values[key]?
    end

    def hide(key : String) : Void
      @hidden_items.add(key)
    end

    def show(key : String) : Void
      @hidden_items.delete(key)
    end

    def visible?(key : String) : Bool
      !@hidden_items.includes?(key)
    end

    def hide_category(category : String) : Void
      @hidden_categories.add(category)
    end

    def show_category(category : String) : Void
      @hidden_categories.delete(category)
    end

    def category_visible?(category : String) : Bool
      !@hidden_categories.includes?(category)
    end

    def unregister(key : String) : Void
      @definitions.delete(key)
      @values.delete(key)
      @hidden_items.delete(key)
    end

    def items_by_category : Hash(String, Array({ItemDefinition, String?}))
      result = Hash(String, Array({ItemDefinition, String?})).new

      @definitions.each do |key, definition|
        next unless visible?(key)
        next unless category_visible?(definition.category)

        result[definition.category] ||= Array({ItemDefinition, String?}).new
        result[definition.category] << {definition, @values[key]?}
      end

      result
    end
  end
end
