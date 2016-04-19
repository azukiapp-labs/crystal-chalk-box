require "./colors"

# [ANSI escape codes](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors_and_Styles) for styling strings in the terminal
#
# This module is based in [chalk/ansi-styles](https://github.com/chalk/ansi-styles)
#
# ## Usage
#
# ```
# require "chalk-box"
# include ChalkBox::Styles
#
# puts "#{red}Red#{reset}"
# puts "#{green.open}Green#{green.close}"
# ```
#
# ## API
# Each style has an open and close property (except reset)
#
module ChalkBox::Styles
  # :nodoc:
  ESCAPE_CODE = "\e"

  # :nodoc:
  module Private::Stringify
    def to_s
      self.open
    end

    def to_s(io : IO)
      io << to_s
    end
  end

  # :nodoc:
  module Private::Reset
    extend Stringify

    macro escape(code = 0)
      "#{ESCAPE_CODE}[#{{{code}}}m"
    end

    def close
      escape
    end

    def open
      close
    end

    def reset
      close
    end
  end

  # Default reset methods expose
  include Private::Reset

  # :nodoc:
  macro group(group_name, key, color, bg = false, method = nil)
    module {{group_name.id}}
      extend self
      include Private::Reset

      module {{color.camelcase.id}}
        extend self
        extend Private::Stringify
        include Private::Reset

        def open
          escape(Colors::{{key.id}}_{{color.upcase.id}}[0])
        end

        def close
          escape(Colors::{{key.id}}_{{color.upcase.id}}[1])
        end
      end

      def {{color.id}}
        {{color.camelcase.id}}
      end

      {% if bg %}
        def bg{{color.camelcase.id}}
          {{color.camelcase.id}}
        end
      {% end %}
    end

    def {{(bg ? "bg#{color.camelcase.id}" : color).id}}
      {{group_name.id}}::{{color.camelcase.id}}
    end
  end

  {% for name in Colors::COLORS %}
    group Color, FORE, {{name}}
    group BgColor, BACK, {{name}}, bg: true
  {% end %}

  {% for name in Colors::MODIFIERS %}
    group Modifier, MOD, {{name}}
  {% end %}

  def modifier
    Modifier
  end

  def color
    Color
  end

  def bgColor
    BgColor
  end

  extend self
end
