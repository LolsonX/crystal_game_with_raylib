module Debug
  class Renderer
    getter config : Config

    @current_y : Int32 = 0

    def initialize(@config : Config = Config.new)
    end

    def render(items_by_category : Hash(String, Array({Registry::ItemDefinition, String?}))) : Void
      @current_y = config.start_y
      draw_background

      items_by_category.each do |category, items|
        next if items.empty?

        box_height = calculate_category_height(items)
        draw_category_box(@current_y, box_height)

        draw_category_header(category)
        items.each do |definition, value|
          draw_item(definition, value)
        end

        @current_y += config.location.box_padding * 2 + config.location.category_spacing
      end
    end

    private def draw_background : Void
      CrystalRaylib::Shapes.draw_rectangle(
        x: config.location.screen_position.x.to_i,
        y: config.location.screen_position.y.to_i,
        width: config.dimensions.width,
        height: config.dimensions.height,
        color: config.style.background_color
      )
    end

    private def calculate_category_height(items : Array({Registry::ItemDefinition, String?})) : Int32
      item_count = items.size + 1
      (item_count * config.line_height) + (config.location.box_padding * 2)
    end

    private def draw_category_box(y : Int32, height : Int32) : Void
      box_x = config.location.screen_position.x.to_i + config.location.box_padding
      box_y = y - config.location.box_padding
      box_width = config.dimensions.width - (config.location.box_padding * 2)

      CrystalRaylib::Shapes.draw_rectangle_lines_ex(
        x: box_x,
        y: box_y,
        width: box_width,
        height: height,
        line_thick: config.style.outline_thickness,
        color: config.style.outline_color
      )
    end

    private def draw_category_header(category : String) : Void
      CrystalRaylib::Text.draw_text(
        text: "[#{category}]",
        x: config.start_x,
        y: @current_y,
        size: config.style.font_size,
        color: config.style.category_color
      )
      advance_line
    end

    private def draw_item(definition : Registry::ItemDefinition, value : String?) : Void
      display_value = value || "N/A"
      CrystalRaylib::Text.draw_text(
        text: "#{definition.label}: #{display_value}",
        x: config.start_x,
        y: @current_y,
        size: config.style.font_size,
        color: config.style.text_color
      )
      advance_line
    end

    private def advance_line : Void
      @current_y += config.line_height
    end
  end
end
