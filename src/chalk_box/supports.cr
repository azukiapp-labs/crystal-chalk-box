# Detect whether a terminal supports color
#
# This module is based in [chalk/supports-color](https://github.com/chalk/supports-color)
#
# ## API
#
# The returned object specifies a level of support for color through a
# `.level` property and a corresponding flag:
#
# ```text
# .level = 1 and .hasBasic = true: Basic color support (16 colors)
# .level = 2 and .has256 = true: 256 color support
# .level = 3 and .has16m = true: 16 million (truecolor) support
# ```
#
# ## Info
#
# It obeys the `--color` and `--no-color` CLI flags.
#
# For situations where using `--color` is not possible,
# add an environment variable `FORCE_COLOR` with any value to force color.
# Trumps `--no-color`.
#
# Explicit 256/truecolor mode can be enabled using the
# `--color=256` and `--color=16m` flags, respectively.
#
class ChalkBox::Supports
  def initialize(@env = ENV, @argv = ARGV, @stdout = STDOUT)
    @level = -1
    @argv = @argv.take_while { |arg| arg != "--" }
  end

  # :nodoc:
  class LocalMacros
    # But have a explanation
    macro def_has(name, level, label)
      # Checks (if not already) and returns if have supports for {{label.id}}
      def {{name.id}}
        return level >= {{level}}
      end
    end
  end

  LocalMacros.def_has(hasBasic, 1, "basic ANSI colors")
  LocalMacros.def_has(has256, 2, "256 colors")
  LocalMacros.def_has(has16m, 3, "16m colors")

  # Checks (if not already) and returns colors support level
  #
  # Code levels:
  #
  # ```text
  # 1 - for basic supports
  # 2 - for 256 colors supports
  # 3 - for 16m colors supports
  # ```
  def level
    if (@level < 0)
      @level = support
      @level = 1 if @level == 0 && env_flag(@env, "FORCE_COLOR")
    end
    return @level
  end

  private def support
    if has_flag(@argv, [
         "color=false", "colors=false",
         "color=0", "colors=0",
         "no-color", "no-colors",
         "no-colors=false", "no-colors=0",
       ])
      return 0
    elsif has_flag(@argv, [
            "color", "colors",
            "color=true", "colors=true",
            "color=1", "colors=1",
            "color=always", "colors=always",
          ])
      return 1
    elsif has_flag(@argv, ["color=256", "colors=256"])
      return 2
    elsif has_flag(@argv, [
            "color=full", "colors=full",
            "color=16m", "colors=16m",
            "color=truecolor", "colors=truecolor",
          ])
      return 3
    elsif !@stdout.tty?
      return 0
    elsif env_flag(@env, "COLORTERM")
      return 1
    elsif /^xterm-256(?:color)?/ =~ env_value(@env, "TERM")
      return 2
    elsif /^screen|^xterm|^vt100|color|ansi|cygwin|linux/i =~ env_value(@env, "TERM")
      return 1
    else
      return 0
    end
  end

  private def env_value(env, key)
    env[key]?
  end

  private def env_flag(env, key)
    value = env_value(env, key)
    !(value.nil? || ["false", "0", "not"].includes?(value))
  end

  private def has_flag(argv, flags : Array)
    flags.any? { |flag| has_flag(argv, flag) }
  end

  private def has_flag(argv, flag : String)
    argv.includes?("--#{flag}")
  end
end
