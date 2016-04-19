require "./supports"
require "./styles"

class ChalkBox::Base
  @enable : Bool | Supports
  alias Buffer = Array(String)

  def initialize(@buffer = [] of Buffer, @enable = Supports.new)
  end

  def styles
    ChalkBox::Styles
  end

  private def buffering(buffer, enable)
    return self unless is_enable(enable)
    reset_buffer
    ChalkBox::Base.new buffer, enable
  end

  private def add_buffer(open, close)
    @buffer << [open, close]
  end

  private def format!(buffer, *args)
    reset_buffer
    format(buffer, *args)
  end

  private def format(buffer, *args)
    text = args.join(" ")
    return text unless is_enable(@enable)
    formated = text.split("\n").map do |line|
      next line if line.empty?
      buffer.reverse.reduce(line) do |text, color|
        "#{color[0]}#{text}#{color[1]}"
      end
    end
    formated.join("\n")
  end

  private def reset_buffer
    @buffer = [] of Buffer
  end

  private def is_enable(enable : Bool)
    enable
  end

  private def is_enable(enable : Supports)
    enable.hasBasic
  end

  # :nodoc:
  macro def_modifier(name)
    private def buffering_{{name.id}}()
      {% if name == "reset" %}
        color = Styles.{{name.id}}
        add_buffer(color, color)
      {% else %}
        add_buffer(Styles.{{name.id}}.open, Styles.{{name.id}}.close)
      {% end %}
    end

    def {{name.id}}()
      buffering_{{name.id}}
      buffering(@buffer, @enable)
    end

    def {{name.id}}(*args)
      buffering_{{name.id}}
      format!(@buffer, *args)
    end
  end

  {% for name in Styles::Colors::COLORS %}
    def_modifier({{name}})
    def_modifier(bg{{name.camelcase.id}})
  {% end %}
  def_modifier("reset")

  {% for name in Styles::Colors::MODIFIERS %}
    def_modifier({{name}})
  {% end %}
end
