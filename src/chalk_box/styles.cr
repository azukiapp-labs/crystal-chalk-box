module ChalkBox::Styles
  FORE_DEFAULT       = ["39", "39"]
  FORE_BLACK         = ["30", "39"]
  FORE_RED           = ["31", "39"]
  FORE_GREEN         = ["32", "39"]
  FORE_YELLOW        = ["33", "39"]
  FORE_BLUE          = ["34", "39"]
  FORE_MAGENTA       = ["35", "39"]
  FORE_CYAN          = ["36", "39"]
  FORE_GRAY          = ["37", "39"]
  FORE_GREY          = FORE_GRAY
  FORE_LIGHT_GRAY    = FORE_GRAY
  FORE_LIGHT_GREY    = FORE_GRAY
  FORE_DARK_GRAY     = ["90", "39"]
  FORE_DARK_GREY     = FORE_DARK_GRAY
  FORE_LIGHT_RED     = ["91", "39"]
  FORE_LIGHT_GREEN   = ["92", "39"]
  FORE_LIGHT_YELLOW  = ["93", "39"]
  FORE_LIGHT_BLUE    = ["94", "39"]
  FORE_LIGHT_MAGENTA = ["95", "39"]
  FORE_LIGHT_CYAN    = ["96", "39"]
  FORE_WHITE         = ["97", "39"]

  BACK_DEFAULT       = ["49", "49"]
  BACK_BLACK         = ["40", "49"]
  BACK_RED           = ["41", "49"]
  BACK_GREEN         = ["42", "49"]
  BACK_YELLOW        = ["43", "49"]
  BACK_BLUE          = ["44", "49"]
  BACK_MAGENTA       = ["45", "49"]
  BACK_CYAN          = ["46", "49"]
  BACK_GRAY          = ["47", "49"]
  BACK_GREY          = BACK_GRAY
  BACK_LIGHT_GRAY    = BACK_GRAY
  BACK_LIGHT_GREY    = BACK_GRAY
  BACK_DARK_GRAY     = ["100", "49"]
  BACK_DARK_GREY     = BACK_DARK_GRAY
  BACK_LIGHT_RED     = ["101", "49"]
  BACK_LIGHT_GREEN   = ["102", "49"]
  BACK_LIGHT_YELLOW  = ["103", "49"]
  BACK_LIGHT_BLUE    = ["104", "49"]
  BACK_LIGHT_MAGENTA = ["105", "49"]
  BACK_LIGHT_CYAN    = ["106", "49"]
  BACK_WHITE         = ["107", "49"]

  MODE_DEFAULT   = ["0", "0"]
  MODE_BOLD      = ["1", "22"]
  MODE_BRIGHT    = ["1", "22"]
  MODE_DIM       = ["2", "23"]
  MODE_UNDERLINE = ["4", "34"]
  MODE_BLINK     = ["5", "27"]
  MODE_REVERSE   = ["7", "28"]
  MODE_HIDDEN    = ["8", "29"]

  COLORS = %w(black red green yellow blue magenta cyan gray grey light_gray light_grey dark_gray dark_grey light_red light_green light_yellow light_blue light_magenta light_cyan white)
  MODES  = %w(bold bright dim underline blink reverse hidden)

  module Groups
    def to_s
      self.open
    end

    def to_s(io : IO)
      io << to_s
    end
  end

  module Reset
    extend Groups

    def close
      "\u001b[0m"
    end

    def open
      close
    end

    def reset
      close
    end
  end

  macro group(group_name, key, color, bg = false, method = nil)
    module {{group_name.id}}
      extend self
      include Reset

      module {{color.camelcase.id}}
        extend self
        extend Groups
        include Reset

        def open
          "\u001b[#{{{key.id}}_{{color.upcase.id}}[0]}m"
        end

        def close
          "\u001b[#{{{key.id}}_{{color.upcase.id}}[1]}m"
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

  {% for name in COLORS %}
    group Color, FORE, {{name}}
    group BgColor, BACK, {{name}}, bg: true
  {% end %}

  {% for name in MODES %}
    group Modifier, MODE, {{name}}
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

  include Reset
end
